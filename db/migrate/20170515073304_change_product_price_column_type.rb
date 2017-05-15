class ChangeProductPriceColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :price, :float, precision: 10, scale: 2
  end
end
