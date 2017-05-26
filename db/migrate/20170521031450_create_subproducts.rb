class CreateSubproducts < ActiveRecord::Migration[5.0]
  def change
    create_table :subproducts do |t|
      t.integer :product_id
      t.string :subtitle
      t.decimal :msrp,       precision: 10, scale: 2
      t.decimal :price,       precision: 10, scale: 2
      t.string :activity
      t.integer :carriage, default: 0
      t.string :place
      t.integer :quantity
      t.string :subproduct_image
      t.timestamps
    end
    add_index :subproducts, [:product_id]
    add_index :subproducts, [:subtitle]
  end
end
