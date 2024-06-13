class DriversController < ApplicationController
  def show
    @driver = Driver.find(params[:id])
    @reviews = Review.where(receiver: @driver.user)
  end
end
