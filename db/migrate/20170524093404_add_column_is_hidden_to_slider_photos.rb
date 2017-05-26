class AddColumnIsHiddenToSliderPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :slider_photos, :is_hidden, :boolean, default: false
  end
end
