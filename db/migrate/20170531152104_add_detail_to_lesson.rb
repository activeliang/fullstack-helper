class AddDetailToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :category_id, :integer
    add_column :chapters, :weight, :integer
    add_column :posts, :weight, :integer
  end
end
