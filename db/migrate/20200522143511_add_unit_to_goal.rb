class AddUnitToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :units, :string, default: 'kg', null: false
  end
end
