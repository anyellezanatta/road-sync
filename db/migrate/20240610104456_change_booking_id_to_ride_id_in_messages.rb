class ChangeBookingIdToRideIdInMessages < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :messages, :bookings
    remove_reference :messages, :booking, index: true
    add_reference :messages, :ride, foreign_key: true
  end
end
