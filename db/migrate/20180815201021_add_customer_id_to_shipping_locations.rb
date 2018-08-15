class AddCustomerIdToShippingLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_locations, :customer_id, :integer, limit: 8
  end
end
