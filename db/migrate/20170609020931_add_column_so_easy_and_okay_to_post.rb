class AddColumnSoEasyAndOkayToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :so_easy, :integer, default: 0
    add_column :posts, :okay, :integer, default: 0
  end
end
