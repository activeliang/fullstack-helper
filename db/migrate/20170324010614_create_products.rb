class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :quantity
      t.decimal :price,       precision: 10, scale: 3
      t.integer :evaluation_count, default: 0
      t.integer :sales_count, default: 0
      t.integer :category_id
      t.timestamps
    end
    add_index :products, [:title]
    add_index :products, [:category_id]
  end
end
