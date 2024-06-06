class BookingsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.ride = Ride.find(params[:ride_id])
    @booking.status = 'pending'

    if @booking.save
      redirect_to dashboard_path
    else
      render "rides/show", status: :unprocessable_entity
    end
  end

  def cancel
    @booking = Booking.find(params[:id])
    if @booking.is_pending? || @booking.is_confirmed?
      @booking.status = 'cancelled'
      @booking.save

      redirect_to dashboard_path
    else
      render "pages/dashboard", status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:seats)
  end
end
