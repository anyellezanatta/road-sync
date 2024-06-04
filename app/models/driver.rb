class Driver < ApplicationRecord
  belongs_to :user
  has_many :rides
  has_many :bookings, through: :rides
end
