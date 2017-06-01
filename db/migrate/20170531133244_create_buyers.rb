class CreateBuyers < ActiveRecord::Migration[5.0]
  def change
    create_table :buyers do |t|
      t.integer :lesson_id, :user_id
       t.decimal :price,       precision: 10, scale: 2
      t.timestamps
    end

    add_index :buyers, [:user_id]
  end
end
