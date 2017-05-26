class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :contact_name, :cellphone, :address
      t.timestamps
    end
    add_index :addresses, [:user_id]
  end
end
