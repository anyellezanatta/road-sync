class Ride < ApplicationRecord
  belongs_to :driver
  has_many :reviews
  has_many :bookings

  geocoded_by :origin, latitude: :origin_latitude, longitude: :origin_longitude
  after_validation :geocode, if: :will_save_change_to_origin?

  geocoded_by :destination, latitude: :destination_latitude, longitude: :destination_longitude
  after_validation :geocode, if: :will_save_change_to_destination?
end
