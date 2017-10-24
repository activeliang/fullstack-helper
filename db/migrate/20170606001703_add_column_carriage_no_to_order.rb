class AddColumnCarriageNoToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :carriage_no, :string
  end
end
