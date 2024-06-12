class AddOriginAndDestinationAddressToRides < ActiveRecord::Migration[7.1]
  def change
    add_column :rides, :origin_address, :string
    add_column :rides, :destination_address, :string
  end
end
