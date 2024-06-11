class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.where(user: current_user)
  end
end
