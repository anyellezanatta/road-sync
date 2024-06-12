class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.where(driver: current_user).or(Chatroom.where(passenger: current_user))
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    ride = Ride.find(params[:ride_id])
    @existing_chatroom = Chatroom.find_by(ride_id: params[:ride_id], driver: ride.driver, passenger: current_user)
    if @existing_chatroom.nil?
      @chatroom = Chatroom.new(chatroom_params)
      @chatroom.driver = ride.driver
      @chatroom.passenger = current_user
      if @chatroom.save
        redirect_to ride_chatroom_path(ride, @chatroom, origin: params[:origin], destination: params[:destination],
                                                        date: params[:date], passengers: params[:passengers])
      end
    else
      redirect_to ride_chatroom_path(ride, @existing_chatroom, origin: params[:origin],
                                                               destination: params[:destination], date: params[:date], passengers: params[:passengers])
    end
  end

  def show
    @ride = Ride.find(params[:ride_id])
    @chatroom = Chatroom.find(params[:id])
    @messages = Message.where(chatroom: @chatroom)
    @message = Message.new
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:ride_id)
  end
end
