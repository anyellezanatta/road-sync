require_relative "../services/tomtom_service"
class Ride < ApplicationRecord
  belongs_to :driver
  has_many :bookings
  has_many :chatrooms
  has_many :ride_points, dependent: :destroy

  before_save :geocode_endpoints
  after_save :calculate_routes

  private

  def calculate_routes
    tomtom_service = TomtomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    points = tomtom_service.calculate_route("#{origin_latitude},#{origin_longitude}",
                                            "#{destination_latitude},#{destination_longitude}")

    points.each { |point| RidePoint.create(ride: self, latitude: point["latitude"], longitude: point["longitude"]) }
  end

  def geocode_endpoints
    tomtom_service = TomtomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    if origin_changed?
      geocoded = tomtom_service.geocode_endpoints(origin_address)

      if geocoded
        self.origin_latitude = geocoded["lat"]
        self.origin_longitude = geocoded["lon"]
      end
    end

    return unless destination_changed?

    geocoded = tomtom_service.geocode_endpoints(destination_address)

    return unless geocoded

    self.destination_latitude = geocoded["lat"]
    self.destination_longitude = geocoded["lon"]
  end
end
