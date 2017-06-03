class AddColumnPaymentAtToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :payment_at, :datetime
  end
end
