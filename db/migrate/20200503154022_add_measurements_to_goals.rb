class AddMeasurementsToGoals < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :goal, foreign_key: true
  end
end
