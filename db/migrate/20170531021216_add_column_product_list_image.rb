class AddColumnProductListImage < ActiveRecord::Migration[5.0]
  def change
    add_column :product_lists, :lists_image, :string
  end
end
