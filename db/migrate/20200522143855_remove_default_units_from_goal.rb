class RemoveDefaultUnitsFromGoal < ActiveRecord::Migration[6.0]
  def change
    change_column_default :goals, :units, nil
  end
end
