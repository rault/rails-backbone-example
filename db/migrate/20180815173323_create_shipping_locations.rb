class CreateShippingLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_locations do |t|
      t.string :name
      t.integer :zip_code

      t.timestamps
    end
  end
end
