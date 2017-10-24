class AddPaymentIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :payment_id, :integer
    add_index :orders, [:payment_id]
  end
end
