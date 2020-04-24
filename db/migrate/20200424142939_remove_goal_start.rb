class RemoveGoalStart < ActiveRecord::Migration[6.0]
  def up
    remove_column :goals, :start_date
    remove_column :goals, :start_value
  end

  def down
    add_column :goals, :start_date, :date
    add_column :goals, :start_value, :decimal
  end
end
