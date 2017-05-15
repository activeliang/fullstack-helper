class ChangeProductListPriceColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :product_lists, :product_price, :float , precision: 10, scale: 2
  end
end
