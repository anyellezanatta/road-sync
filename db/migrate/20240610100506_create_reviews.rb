class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.references :booking, null: false, foreign_key: true
      t.references :reviewer, null: false
      t.references :receiver, null: false
      t.integer :rating, default: 0

      t.timestamps
    end

    add_foreign_key :reviews, :users, column: :reviewer_id
    add_foreign_key :reviews, :users, column: :receiver_id
  end
end
