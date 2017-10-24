class AddColumnOfLessonToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :of_lesson, :boolean, default: false
    add_index :orders, :of_lesson
  end
end
