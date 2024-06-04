class Ride < ApplicationRecord
  belongs_to :driver
  has_many :reviews
  has_many :bookings
end
