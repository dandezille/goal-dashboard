class CreateMeasurements < ActiveRecord::Migration[6.0]
  def change
    create_table :measurements do |t|
      t.date :date, null: false
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
