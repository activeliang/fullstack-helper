class AddColumnLessonIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :lesson_id, :integer
  end
end
