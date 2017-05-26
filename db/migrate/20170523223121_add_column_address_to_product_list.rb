class AddColumnAddressToProductList < ActiveRecord::Migration[5.0]
  def change
    add_column :product_lists, :address, :string
    add_column :product_lists, :cellphone, :string
    add_column :product_lists, :contact_name, :string
    add_column :product_lists, :subproduct, :string
  end
end
