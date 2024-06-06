class RidesController < ApplicationController
  def show
    @ride = Ride.find(params[:id])
  end
end
