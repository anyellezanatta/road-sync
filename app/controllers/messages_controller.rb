class MessagesController < ApplicationController
  def index
    @message = Message.new
    @messages = Message.where(chatroom_id: params[:id])
  end

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.create(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        message: render_to_string(partial: "message", locals: { message: @message }),
        sender_id: @message.user.id
      )

      # redirect_to ride_chatroom_path(@chatroom.ride, @chatroom)
    else
      render "chatrooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :content, :chatroom_id)
  end
end
