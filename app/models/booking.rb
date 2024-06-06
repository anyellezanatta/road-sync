class Booking < ApplicationRecord
  # status we can use
  # status = ['pending', 'confirmed', 'declined', 'cancelled']

  belongs_to :ride
  belongs_to :user
  has_many :messages

  def is_pending?
    status == 'pending'
  end

  def is_confirmed?
    status == 'confirmed'
  end

  def is_declined?
    status == 'declined'
  end

  def is_cancelled?
    status == 'cancelled'
  end
end
