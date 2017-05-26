class CreateProductPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :product_photos do |t|
      t.integer :product_id
      t.integer :weight, default: 0
      t.string :product_image
      t.timestamps
    end
    add_index :product_photos, [:product_id]
  end
end
