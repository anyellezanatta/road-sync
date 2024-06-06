class Ride < ApplicationRecord
  belongs_to :driver
  has_many :reviews
  has_many :bookings

  geocoded_by :origin, latitude: :origin_latitude, longitude: :origin_longitude
  geocoded_by :destination, latitude: :destination_latitude, longitude: :destination_longitude

  # after_validation :geocode, if: :origin_destination_changed?
  before_save :geocode_endpoints

  private

  def geocode_endpoints
    if origin_changed?
      geocoded = Geocoder.search(origin).first
      if geocoded
        self.origin_latitude = geocoded.latitude
        self.origin_longitude = geocoded.longitude
      end
    end

    if destination_changed?
      geocoded = Geocoder.search(destination).first
      if geocoded
        self.destination_latitude = geocoded.latitude
        self.destination_longitude = geocoded.longitude
      end
    end
  end
end
