class RenameColumnDepartureLocationAndDepartureTimeToRides < ActiveRecord::Migration[7.1]
  def change
    rename_column :rides, :departure_location, :origin
    rename_column :rides, :departure_time, :start_time
  end
end
