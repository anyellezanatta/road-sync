require_relative "../services/tomtom_service"

class RidesController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def show
    @ride = Ride.find(params[:id])
    @reviews = Review.where(receiver_id: @ride.driver.user_id)
    @chatroom = Chatroom.find_by(ride: @ride, driver: @ride.driver.user, passenger: current_user)
    @chatroom = Chatroom.new if @chatroom.nil?
    @booking = Booking.new
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
    return unless user_points.count != 0

    @rides = find_matching_rides(user_points, @rides)
  end

  private

  def calculate_route(origin, destination)
    tomtom_service = TomtomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    geocodedOrigin = tomtom_service.geocode_endpoints(origin)
    geocodedDestination = tomtom_service.geocode_endpoints(destination)

    tomtom_service.calculate_route("#{geocodedOrigin['lat']},#{geocodedOrigin['lon']}",
                                   "#{geocodedDestination['lat']},#{geocodedDestination['lon']}")
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

    matching_percentage >= 20
  end

  def get_map_data(origin, destination)
    tomtom_service = TomtomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    geocodedOrigin = tomtom_service.geocode_endpoints(origin)
    geocodedDestination = tomtom_service.geocode_endpoints(destination)

    return {} if geocodedOrigin.nil? || geocodedDestination.nil?

    return { ride: { origin: { city: @ride.origin.capitalize, latitude: @ride.origin_latitude, longitude: @ride.origin_longitude },
                     destination: { city: @ride.destination.capitalize, latitude: @ride.destination_latitude,
                                    longitude: @ride.destination_longitude }, price_per_km: @ride.price_per_km },
             user: { origin: { city: params[:origin].capitalize, latitude: geocodedOrigin["lat"], longitude: geocodedOrigin["lon"] },
                     destination: { city: params[:destination].capitalize, latitude: geocodedDestination["lat"],
                                    longitude: geocodedDestination["lon"] } } }.to_json
  end
end
