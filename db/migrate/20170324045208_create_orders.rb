class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
       t.decimal :price,       precision: 10, scale: 2
       t.integer :user_id
      t.timestamps
    end
  end
end
