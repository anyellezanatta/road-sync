class ChangeRideIdToChatIdInMessages < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :messages, :rides
    remove_reference :messages, :ride, index: true
    add_reference :messages, :chatroom, foreign_key: true
  end
end
