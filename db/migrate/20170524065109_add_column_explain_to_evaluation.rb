class AddColumnExplainToEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :explain, :text
  end
end
