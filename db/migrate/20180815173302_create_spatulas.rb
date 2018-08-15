class CreateSpatulas < ActiveRecord::Migration[5.2]
  def change
    create_table :spatulas do |t|
      t.string :color
      t.decimal :price

      t.timestamps
    end
  end
end
