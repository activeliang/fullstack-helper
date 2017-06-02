class CreateChapters < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.string :title
      t.integer :lesson_id
      t.timestamps
    end
  end
end
