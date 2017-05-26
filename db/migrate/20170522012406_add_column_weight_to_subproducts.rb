class AddColumnWeightToSubproducts < ActiveRecord::Migration[5.0]
  def change
    add_column :subproducts, :weight, :integer, default: 0
  end
end
