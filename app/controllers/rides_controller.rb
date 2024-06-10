require_relative "../services/tomtom_service"

class RidesController < ApplicationController
  def show
    @ride = Ride.find(params[:id])
    @booking = Booking.new
    # @users = User.all
    @reviews = Review.where(receiver_id: @ride.driver.user_id)
  end

  def index
    tomtom_service = TomTomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    @rides = Ride.joins(:driver).where.not(driver: { user: current_user }).order(:start_time)
    @destination = ""

    search = params[:search]
    return unless params[:search].present?
    return unless search[:origin].present? || search[:destination].present? || search[:date].present?

    origin = search[:origin].downcase
    @destination = search[:destination].downcase
    @date = Date.parse(search[:date])
    passengers = search[:seats].to_i
    sql_subquery = "DATE(date) = :date #{search[:seats].present? ? 'AND seats >= :passengers' : ''}"
    @rides = @rides.where(sql_subquery, date: @date,
                                        passengers:).order(:start_time)

    geocodedOrigin = Geocoder.search(origin).first
    geocodedDestination = Geocoder.search(@destination).first

    user_response = tomtom_service.calculate_route("#{geocodedOrigin.latitude},#{geocodedOrigin.longitude}",
                                                   "#{geocodedDestination.latitude},#{geocodedDestination.longitude}")
    user_points = user_response["routes"].first["legs"].first["points"]
    @rides = find_matching_rides(user_points, @rides)
  end

  private

  def find_matching_rides(user_points, rides)
    rides.select do |ride|
      ride_points = ride.ride_points.map { |point| { "latitude" => point.latitude, "longitude" => point.longitude } }
      routes_match?(user_points, ride_points)
    end
  end

  def routes_match?(user_points, driver_points)
    matching_points = user_points & driver_points
    matching_percentage = (matching_points.size.to_f / user_points.size) * 100

    matching_percentage >= 80
  end
end
