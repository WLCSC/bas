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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120823164232) do

  create_table "appointments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "slot_id"
    t.integer  "kind_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  add_index "appointments", ["slot_id"], :name => "slot_id"
  add_index "appointments", ["user_id"], :name => "user_id"

  create_table "bookables", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "bookables", ["user_id"], :name => "user_id"

  create_table "kinds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slots", :force => true do |t|
    t.string   "name"
    t.integer  "bookable_id"
    t.integer  "start_time"
    t.integer  "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "special"
  end

  add_index "slots", ["bookable_id"], :name => "bookable_id"
  add_index "slots", ["end_time"], :name => "end_time"
  add_index "slots", ["start_time"], :name => "start_time"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.boolean  "administrator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
