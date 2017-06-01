class AddColumnPriceToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :price, :decimal,   precision: 10, scale: 2
  end
end
