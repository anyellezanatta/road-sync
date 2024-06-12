require_relative "../services/tomtom_service"

class RidesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def show
    @ride = Ride.find(params[:id])
    @reviews = Review.where(receiver_id: @ride.driver.user_id)
    @booking = Booking.new
    @chatroom = Chatroom.new
    @map_data = get_map_data(params[:origin], params[:destination])
  end

  def index
    search = params[:search]
    if !params[:search].present? || !search[:origin].present? || !search[:destination].present? || !search[:date].present?
      return render "pages/home", status: :unprocessable_entity
    end

    @origin = search[:origin].downcase

    @destination = search[:destination].downcase
    @date = Date.parse(search[:date])
    @passengers = search[:seats].to_i

    @rides = Ride.joins(:driver).where.not(driver: { user: current_user }).order(:start_time)
    sql_subquery = "DATE(date) = :date #{search[:seats].present? ? 'AND seats >= :passengers' : ''}"

    @rides = @rides.where(sql_subquery, date: @date,
                                        passengers: @passengers).order(:start_time)

    user_points = calculate_route(@origin, @destination)
    @rides = find_matching_rides(user_points, @rides)
  end

  private

  def calculate_route(origin, destination)
    tomtom_service = TomTomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    geocodedOrigin = geocodedAddresses(origin)
    geocodedDestination = geocodedAddresses(destination)

    user_response = tomtom_service.calculate_route("#{geocodedOrigin.latitude},#{geocodedOrigin.longitude}",
                                                   "#{geocodedDestination.latitude},#{geocodedDestination.longitude}")

    return user_response["routes"].first["legs"].first["points"]
  end

  def find_matching_rides(user_points, rides)
    rides.select do |ride|
      ride_points = ride.ride_points.map { |point| { "latitude" => point.latitude, "longitude" => point.longitude } }
      routes_match?(user_points, ride_points)
    end
  end

  def routes_match?(user_points, driver_points)
    matching_points = user_points & driver_points
    matching_percentage = (matching_points.size.to_f / user_points.size) * 100

    matching_percentage >= 50
  end

  def geocodedAddresses(address)
    Geocoder.search(address).first
  end

  def get_map_data(origin, destination)
    geocodedOrigin = geocodedAddresses(origin)
    geocodedDestination = geocodedAddresses(destination)

    return {} if geocodedOrigin.nil? || geocodedDestination.nil?

    return { ride: { origin: { city: @ride.origin.capitalize, latitude: @ride.origin_latitude, longitude: @ride.origin_longitude },
                     destination: { city: @ride.destination.capitalize, latitude: @ride.destination_latitude,
                                    longitude: @ride.destination_longitude } },
             user: { origin: { city: params[:origin].capitalize, latitude: geocodedOrigin.latitude, longitude: geocodedOrigin.longitude },
                     destination: { city: params[:destination].capitalize, latitude: geocodedDestination.latitude,
                                    longitude: geocodedDestination.longitude } } }.to_json
  end
end
