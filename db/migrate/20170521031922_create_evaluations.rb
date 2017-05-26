class CreateEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :grade, default: 5
      t.text :description
      t.string :subtitle
      t.timestamps
    end
    add_index :evaluations, [:user_id]
    add_index :evaluations, [:product_id]
    add_index :evaluations, [:grade]
  end
end
