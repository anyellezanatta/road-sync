class PagesController < ApplicationController
  def home
  end

  def dashboard
    @bookings = Booking.where(user: current_user)
    @driver_bookings = current_user.driver_bookings
  end
end
