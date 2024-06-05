class AddCoordinatesToRides < ActiveRecord::Migration[7.1]
  def change
    add_column :rides, :origin_latitude, :float
    add_column :rides, :origin_longitude, :float
    add_column :rides, :destination_latitude, :float
    add_column :rides, :destination_longitude, :float
  end
end
