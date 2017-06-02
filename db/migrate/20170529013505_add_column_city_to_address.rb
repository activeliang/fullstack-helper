class AddColumnCityToAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :province, :string
    add_column :addresses, :city, :string
    add_column :addresses, :district, :string
  end
end
