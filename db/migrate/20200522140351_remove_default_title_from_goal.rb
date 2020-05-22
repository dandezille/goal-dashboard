class RemoveDefaultTitleFromGoal < ActiveRecord::Migration[6.0]
  def change
    change_column_default :goals, :title, nil
  end
end
