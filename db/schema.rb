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

ActiveRecord::Schema[7.0].define(version: 2022_02_16_045104) do
  create_table "comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["created_at"], name: "index_comments_on_created_at"
  end

  create_table "retailers", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0, null: false, unsigned: true
    t.integer "stores_count", default: 0, null: false, unsigned: true
    t.datetime "latest_comment_date"
    t.datetime "latest_store_add_date"
    t.index ["active", "id", "url"], name: "index_retailers_on_active_and_id_and_url"
    t.index ["active", "latest_comment_date"], name: "index_retailers_on_active_and_latest_comment_date"
    t.index ["active", "latest_store_add_date"], name: "index_retailers_on_active_and_latest_store_add_date"
    t.index ["url"], name: "index_retailers_on_url", unique: true
  end

  create_table "states", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "state_code", limit: 10, default: "na", null: false
    t.string "country_code", limit: 2, default: "us", null: false
    t.string "state_name", limit: 128, default: "Undefined", null: false
    t.index ["country_code", "state_code"], name: "index_states_on_country_code_and_state_code", unique: true
  end

  create_table "store_attributes", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "store_id", null: false, unsigned: true
    t.text "attr", size: :long, collation: "utf8mb4_bin"
    t.index ["store_id"], name: "index_store_attributes_on_store_id"
    t.check_constraint "json_valid(`attr`)", name: "attr"
  end

  create_table "stores", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "retailer_id", null: false, unsigned: true
    t.integer "state_id", null: false, unsigned: true
    t.string "name", limit: 128
    t.string "addr_ln_1"
    t.string "addr_ln_2"
    t.string "city", limit: 128
    t.float "latitude"
    t.float "longitude"
    t.integer "active", limit: 1, default: 1
    t.integer "comments_count", default: 0, null: false, unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "latest_comment_date"
    t.string "zip_code", limit: 15
    t.index ["active", "retailer_id", "id"], name: "index_stores_on_active_and_retailer_id_and_id"
    t.index ["active", "retailer_id", "latest_comment_date"], name: "index_stores_on_active_and_retailer_id_and_latest_comment_date"
    t.index ["active", "retailer_id", "updated_at"], name: "index_stores_on_active_and_retailer_id_and_updated_at"
    t.index ["retailer_id"], name: "index_stores_on_retailer_id"
    t.index ["state_id"], name: "index_stores_on_state_id"
  end

  add_foreign_key "store_attributes", "stores"
  add_foreign_key "stores", "retailers"
  add_foreign_key "stores", "states"
end
