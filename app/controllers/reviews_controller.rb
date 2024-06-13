class ReviewsController < ApplicationController
  def new
    # We need @restaurant in our `simple_form_for`
    @booking = Booking.find(params[:booking_id])
    @review = Review.new
  end

    before_action :set_booking, only: %i[new create]

    def create
      @review = Review.new(review_params)
      @review.booking = @booking
      @review.reviewer = current_user
      @review.receiver = @booking.ride.driver.user
      @review.save
      redirect_to dashboard_path
    end

    private

    def set_booking
      @booking = Booking.find(params[:booking_id])
    end

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
