class AddColumnSloganToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :slogan, :string
  end
end
