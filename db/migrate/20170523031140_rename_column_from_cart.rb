class RenameColumnFromCart < ActiveRecord::Migration[5.0]
  def change
    rename_column :cart_items, :product_id, :subproduct_id
  end
end
