class AddStartValueToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :start_value, :decimal, default: 0, null: false
    change_column_default :goals, :start_value, default: nil
    rename_column :goals, :value, :end_value
  end
end
