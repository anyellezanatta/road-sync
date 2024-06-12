class DriversController < ApplicationController
  def show
    @driver = Driver.find(params[:id])
  end
end
