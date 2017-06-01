class AddColumnWeightToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :weight, :integer
  end
end
