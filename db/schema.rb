# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090129205012) do

  create_table "content_servers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "username"
    t.string   "password"
    t.string   "server_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sms_computer_group_dynamic_membership_rules", :force => true do |t|
    t.integer  "computer_group_id"
    t.integer  "limiting_computer_group_id"
    t.string   "name"
    t.string   "query"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_computer_group_static_membership_rules", :force => true do |t|
    t.integer  "computer_group_id"
    t.integer  "computer_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_computer_groups", :force => true do |t|
    t.string   "remote_id"
    t.integer  "content_server_id"
    t.string   "name"
    t.date     "last_cached"
    t.date     "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_computers", :force => true do |t|
    t.string   "remote_id"
    t.integer  "content_server_id"
    t.string   "name"
    t.string   "user"
    t.date     "last_cached"
    t.date     "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_package_deployments", :force => true do |t|
    t.integer  "computer_group_id"
    t.integer  "package_id"
    t.string   "program_name"
    t.datetime "expire_date"
    t.string   "name"
    t.integer  "content_server_id"
    t.string   "remote_id"
    t.date     "last_cached"
    t.date     "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_packages", :force => true do |t|
    t.string   "remote_id"
    t.string   "manufacturer"
    t.string   "version"
    t.integer  "content_server_id"
    t.string   "name"
    t.date     "last_cached"
    t.date     "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_tasks", :force => true do |t|
    t.string   "name"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabs", :force => true do |t|
    t.string   "content_id"
    t.string   "content_type"
    t.integer  "tabset_id"
    t.integer  "position"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_server_id"
  end

  create_table "tabsets", :force => true do |t|
    t.string   "active_tab_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
