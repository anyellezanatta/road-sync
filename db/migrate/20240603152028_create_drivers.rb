class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers do |t|
      t.string :dl_number
      t.string :car_number_plate
      t.string :car_model
      t.string :car_color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
