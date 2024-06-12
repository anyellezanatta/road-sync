class AddLocationFeildsToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :origin, :string
    add_column :bookings, :origin_address, :string
    add_column :bookings, :destination, :string
    add_column :bookings, :destination_address, :string
    add_column :bookings, :origin_latitude, :float
    add_column :bookings, :origin_longitude, :float
    add_column :bookings, :destination_latitude, :float
    add_column :bookings, :destination_longitude, :float
  end
end
