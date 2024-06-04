class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.references :driver, null: false, foreign_key: true
      t.integer :seats
      t.date :date
      t.datetime :departure_time
      t.string :departure_location
      t.string :destination
      t.text :remarks
      t.string :price_per_km

      t.timestamps
    end
  end
end
