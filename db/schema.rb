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

ActiveRecord::Schema.define(version: 2022_01_26_173151) do

  create_table "retailers", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active", "id", "url"], name: "index_retailers_on_active_and_id_and_url"
    t.index ["url"], name: "index_retailers_on_url", unique: true
  end

end
