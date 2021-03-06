# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151218111822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classtables", force: :cascade do |t|
    t.string   "subject_code"
    t.string   "subject"
    t.integer  "daily"
    t.integer  "start"
    t.integer  "finish"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "table_id"
    t.string   "room"
    t.string   "section"
    t.string   "color"
    t.string   "dayFinal"
    t.string   "timeFinal"
    t.string   "dayMidterm"
    t.string   "timeMidterm"
    t.integer  "user_id"
  end

  add_index "classtables", ["table_id"], name: "index_classtables_on_table_id", using: :btree
  add_index "classtables", ["user_id"], name: "index_classtables_on_user_id", using: :btree

  create_table "days", force: :cascade do |t|
    t.string   "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regularexams", force: :cascade do |t|
    t.integer  "dayexam"
    t.integer  "timeexam"
    t.string   "dateexam"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "yearexam"
    t.integer  "semesterexam"
    t.integer  "ordered"
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "semester"
  end

  add_index "tables", ["user_id"], name: "index_tables_on_user_id", using: :btree

  create_table "timers", force: :cascade do |t|
    t.string   "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
