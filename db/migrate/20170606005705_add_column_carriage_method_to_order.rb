class AddColumnCarriageMethodToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :carriage_method, :string
  end
end
