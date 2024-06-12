require_relative "../services/tomtom_service"
class Ride < ApplicationRecord
  belongs_to :driver
  has_many :reviews, dependent: :destroy
  has_many :bookings
  has_many :ride_points, dependent: :destroy

  geocoded_by :origin, latitude: :origin_latitude, longitude: :origin_longitude
  geocoded_by :destination, latitude: :destination_latitude, longitude: :destination_longitude

  # after_validation :geocode, if: :origin_destination_changed?
  before_save :geocode_endpoints
  after_save :calculate_routes

  private

  def calculate_routes
    tomtom_service = TomTomService.new(ENV.fetch("TOMTOM_API_KEY", nil))

    p origin_latitude
    p destination_latitude
    response = tomtom_service.calculate_route("#{origin_latitude},#{origin_longitude}",
                                              "#{destination_latitude},#{destination_longitude}")
    p response
    return unless response["routes"].present?

    points = response["routes"].first["legs"].first["points"]

    points.each { |point| RidePoint.create(ride: self, latitude: point["latitude"], longitude: point["longitude"]) }
  end

  def geocode_endpoints
    p origin
    if origin_changed?
      geocoded = Geocoder.search(origin).first
      if geocoded
        self.origin_latitude = geocoded.latitude
        self.origin_longitude = geocoded.longitude
      end
    end

    return unless destination_changed?

    p destination
    geocoded = Geocoder.search(destination).first
    return unless geocoded

    self.destination_latitude = geocoded.latitude
    self.destination_longitude = geocoded.longitude
  end
end
