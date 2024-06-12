class CreateRidePoints < ActiveRecord::Migration[7.1]
  def change
    create_table :ride_points do |t|
      t.float :latitude
      t.float :longitude
      t.references :ride, null: false, foreign_key: true

      t.timestamps
    end
  end
end
