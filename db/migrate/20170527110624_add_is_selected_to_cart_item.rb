class AddIsSelectedToCartItem < ActiveRecord::Migration[5.0]
  def change
    add_column :cart_items, :is_selected, :boolean, default: true
  end
end
