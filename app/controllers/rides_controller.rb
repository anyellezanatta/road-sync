class RidesController < ApplicationController
  def show
    @ride = Ride.find(params[:id])
    @booking = Booking.new
    # @users = User.all
    @reviews = Review.where(receiver_id: @ride.driver.user_id)
    @chatroom = Chatroom.new
  end

  def index
    @rides = Ride.joins(:driver).where.not(driver: { user: current_user }).order(:start_time)
    @destination = ""

    search = params[:search]
    return unless params[:search].present?
    return unless search[:origin].present? || search[:destination].present? || search[:date].present?

    origin = search[:origin].downcase
    @destination = search[:destination].downcase
    @date = Date.parse(search[:date])
    passengers = search[:seats].to_i

    sql_subquery = " lower(origin)  @@ :origin
      AND lower(destination)  @@ :destination
      AND DATE(date) = :date #{search[:seats].present? ? 'AND seats >= :passengers' : ''}"

    @rides = @rides.where(sql_subquery, origin:, destination: @destination, date: @date,
                                        passengers:).order(:start_time)
  end
end
