class AddEndDateToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :start_date, :date, default: Date.today, null: false
    change_column_default :goals, :start_date, default: nil
    rename_column :goals, :date, :end_date
  end
end
