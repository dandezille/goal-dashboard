class MakeMeasurementGoalNonNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :measurements, :goal_id, false
  end
end
