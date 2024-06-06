class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :drivers
  has_many :bookings
  has_many :rides, through: :drivers
  has_many :reviewer_reviews, class_name: 'Review', foreign_key: 'reviewer_id'
  has_many :receiver_reviews, class_name: 'Review', foreign_key: 'receiver_id'


  def driver_bookings
    Booking.joins(ride: :driver)
           .where(drivers: { user: self })
  end

end
