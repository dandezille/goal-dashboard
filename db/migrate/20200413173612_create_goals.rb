class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.date :date, null: false
      t.decimal :value, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
