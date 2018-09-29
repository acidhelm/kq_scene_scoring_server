# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180929012433) do

  create_table "tournaments", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "subdomain"
    t.boolean "complete"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tournaments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "password_digest"
    t.string "encrypted_api_key"
    t.string "encrypted_api_key_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

end
