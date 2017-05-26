class CreateEvaluationPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluation_photos do |t|
      t.integer :evaluation_id
      t.string :evaluation_image
      t.timestamps
    end
    add_index :evaluation_photos, [:evaluation_id]
  end
end
