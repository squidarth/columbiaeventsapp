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

ActiveRecord::Schema.define(:version => 20120823194226) do

  create_table "attendings", :force => true do |t|
    t.integer   "user_id"
    t.integer   "event_id"
    t.string    "status"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "attendings", ["event_id"], :name => "index_attendings_on_event_id"
  add_index "attendings", ["user_id"], :name => "index_attendings_on_user_id"

  create_table "authorizations", :force => true do |t|
    t.string    "provider"
    t.string    "uid"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "token"
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "categories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  add_index "categorizations", ["event_id"], :name => "index_categorizations_on_event_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "facebook_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "deleted"
    t.integer  "attendings_count"
    t.datetime "start_time"
  end

  add_index "events", ["facebook_id"], :name => "index_events_on_facebook_id"
  add_index "events", ["start_time"], :name => "index_events_on_start_time"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "about_me"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.boolean  "admin",       :default => false
    t.string   "facebook_id"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"

end
