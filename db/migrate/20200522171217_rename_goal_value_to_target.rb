class RenameGoalValueToTarget < ActiveRecord::Migration[6.0]
  def change
    rename_column :goals, :value, :target
  end
end
