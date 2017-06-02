class AddColumnLessonIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :lesson_id, :integer
  end
end
 
