# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_28_135559) do
  create_table "equipment", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "quantity"
    t.datetime "updated_at", null: false
  end

  create_table "equipment_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "equipment_id", null: false
    t.boolean "is_absence"
    t.time "time"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["equipment_id"], name: "index_equipment_records_on_equipment_id"
    t.index ["user_id"], name: "index_equipment_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "college", default: "Undeclared"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "faculty", default: "Undeclared"
    t.string "major", default: "Undeclared"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "venue_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.boolean "is_absence"
    t.time "time", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "venue_id", null: false
    t.index ["user_id"], name: "index_venue_records_on_user_id"
    t.index ["venue_id"], name: "index_venue_records_on_venue_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "building"
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "venue_id"
    t.index ["name"], name: "index_venues_on_name"
    t.index ["venue_id"], name: "index_venues_on_venue_id", unique: true
  end

  add_foreign_key "equipment_records", "equipment"
  add_foreign_key "equipment_records", "users"
  add_foreign_key "venue_records", "users"
  add_foreign_key "venue_records", "venues"
end
