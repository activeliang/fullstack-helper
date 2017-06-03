class AddColumnSalesCountToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :sales_count, :integer, default: 0
  end
end
