class CreateOrderLines < ActiveRecord::Migration[5.2]
  def change
    create_table :order_lines do |t|
      t.references :order, foreign_key: true
      t.integer :quantity
      t.references :spatula, foreign_key: true
      t.references :shipping_location, foreign_key: true

      t.timestamps
    end
  end
end
