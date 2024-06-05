class RenameColumncarNumberPlateToDrivers < ActiveRecord::Migration[7.1]
  def change
    rename_column :drivers, :car_number_plate, :car_plate
  end
end
