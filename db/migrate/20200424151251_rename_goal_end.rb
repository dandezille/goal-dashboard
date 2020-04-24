class RenameGoalEnd < ActiveRecord::Migration[6.0]
  def up
    rename_column :goals, :end_value, :value
    rename_column :goals, :end_date, :date
  end

  def down
    rename_column :goals, :value, :end_value
    rename_column :goals, :date, :end_date
  end
end
