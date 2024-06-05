class RidesController < ApplicationController
  def index
    @rides = Ride.all

    origin = params[:origin].downcase
    destination = params[:destination].downcase
    date = Date.parse(params[:date])
    passengers = params[:seats].to_i

    sql_subquery = " lower(origin)  @@ :origin
      AND lower(destination)  @@ :destination
      AND DATE(date) = :date #{params[:seats].present? ? 'AND seats >= :passengers' : ''}"

    @rides = @rides.where(sql_subquery, origin:, destination:, date:,
                                        passengers:).order(:start_time)
  end
end
