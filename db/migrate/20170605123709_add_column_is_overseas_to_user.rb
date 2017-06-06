class AddColumnIsOverseasToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_overseas, :boolean, default: false
  end
end
