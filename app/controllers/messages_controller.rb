class MessagesController < ApplicationController
#get access to all params required for message creation
  def index
    @message = Message.new
    @messages = Message.where(booking_id: params[:booking_id], user_id: current_user.id)
  end

  def create
    @message = Message.new(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:content, :booking_id, :user_id)
  end
end
