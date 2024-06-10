class ReviewsController < ApplicationController
  def new
    # We need @restaurant in our `simple_form_for`
    @ride = Ride.find(params[:ride_id])
    @review = Review.new
  end
end
