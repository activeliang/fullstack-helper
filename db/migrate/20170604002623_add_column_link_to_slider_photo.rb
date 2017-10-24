class AddColumnLinkToSliderPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :slider_photos, :link, :string
  end
end
