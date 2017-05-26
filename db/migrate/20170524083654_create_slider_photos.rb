class CreateSliderPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :slider_photos do |t|
      t.string :slider_image
      t.integer :weight
      t.timestamps
    end
  end
end
