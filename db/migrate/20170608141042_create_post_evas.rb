class CreatePostEvas < ActiveRecord::Migration[5.0]
  def change
    create_table :post_evas do |t|
      t.text :content
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
