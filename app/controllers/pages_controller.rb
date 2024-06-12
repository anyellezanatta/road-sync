class PagesController < ApplicationController
  before_action :authenticate_user!, only: %i[dashboard]
  def home
  end

  def dashboard
    if current_user
      @bookings = Booking.where(user: current_user)
      @driver_bookings = current_user.driver_bookings
    end
  end

end
