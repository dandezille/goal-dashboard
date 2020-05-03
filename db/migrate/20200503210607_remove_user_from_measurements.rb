class RemoveUserFromMeasurements < ActiveRecord::Migration[6.0]
  def change
    remove_column :measurements, :user_id
  end
end
