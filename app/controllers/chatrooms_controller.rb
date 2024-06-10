class ChatroomsController < ApplicationController
  def new
    @chatroom = Chatroom.new
  end

  def  show
    @chatroom = Chatroom.find(params[:ride_id])
    @messages = Message.where(chatroom: @chatroom)
    @message = Message.new
  end


end
