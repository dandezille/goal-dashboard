# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_03_210607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'goals', force: :cascade do |t|
    t.date 'date', null: false
    t.decimal 'value', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[user_id], name: 'index_goals_on_user_id'
  end

  create_table 'measurements', force: :cascade do |t|
    t.date 'date', null: false
    t.decimal 'value', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'goal_id', null: false
    t.index %w[goal_id], name: 'index_measurements_on_goal_id'
  end

  create_table 'users', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'email', null: false
    t.string 'encrypted_password', limit: 128, null: false
    t.string 'confirmation_token', limit: 128
    t.string 'remember_token', limit: 128, null: false
    t.index %w[email], name: 'index_users_on_email'
    t.index %w[remember_token], name: 'index_users_on_remember_token'
  end

  add_foreign_key 'goals', 'users'
  add_foreign_key 'measurements', 'goals'
end
