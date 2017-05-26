class CreateProductParams < ActiveRecord::Migration[5.0]
  def change
    create_table :product_params do |t|
      t.integer :product_id
      t.integer :weight
      t.string :content
      t.timestamps
    end
    add_index :product_params, [:product_id]
  end
end
