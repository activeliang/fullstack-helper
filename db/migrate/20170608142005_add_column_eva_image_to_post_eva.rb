class AddColumnEvaImageToPostEva < ActiveRecord::Migration[5.0]
  def change
    add_column :post_evas, :eva_image, :string
  end
end
