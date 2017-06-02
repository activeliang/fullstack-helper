class AddColumnEffectToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :effect, :string
  end
end
