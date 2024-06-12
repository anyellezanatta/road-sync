class CreateChatrooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chatrooms do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :driver, null: false
      t.references :passenger, null: false
      t.timestamps
    end
    add_foreign_key :chatrooms, :users, column: :driver_id
    add_foreign_key :chatrooms, :users, column: :passenger_id
  end
end
