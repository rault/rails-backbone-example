class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
