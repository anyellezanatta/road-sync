class ChatroomsController < ApplicationController
  def new
    @chatroom = Chatroom.new
  end

  def create
      @existing_chatroom = Chatroom.find_by(ride_id: chatroom_params[:ride_id], driver_id: chatroom_params[:driver_id], passenger_id: chatroom_params[:passenger_id])
      if @existing_chatroom.nil?
        @chatroom = Chatroom.create(chatroom_params)
        if @chatroom.save
          redirect_to ride_chatroom_path(chatroom_params[:ride_id], @chatroom)
        end
      else
        redirect_to ride_chatroom_path(chatroom_params[:ride_id], @existing_chatroom)
      end
  end

  def  show
    @ride = Ride.find(params[:ride_id])
    @chatroom = Chatroom.find(params[:id])
    @messages = Message.where(chatroom: @chatroom)
    @message = Message.new
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:ride_id, :driver_id, :passenger_id)
  end
end
