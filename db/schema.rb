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

ActiveRecord::Schema.define(:version => 20090914204145) do

  create_table "action_inventory_objects", :force => true do |t|
    t.integer  "action_id"
    t.integer  "inventory_object_id"
    t.string   "inventory_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.date     "date_of_occurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bundle_members", :force => true do |t|
    t.integer  "bundle_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bundles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "computers", :force => true do |t|
    t.string   "name"
    t.string   "mac_address"
    t.string   "domain"
    t.string   "owner"
    t.string   "system_role"
    t.string   "po_number"
    t.string   "model"
    t.string   "stage"
    t.string   "division"
    t.string   "serial_number"
    t.string   "system_class"
    t.date     "last_audited"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",             :default => true, :null => false
    t.string   "location"
    t.string   "site"
    t.date     "last_stage_change"
    t.integer  "division_id"
  end

  create_table "content_servers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "username"
    t.string   "password"
    t.string   "server_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.string   "divisions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", :force => true do |t|
    t.integer  "package_id"
    t.integer  "computer_id"
    t.string   "po_number"
    t.string   "notes"
    t.string   "division"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license_key"
    t.boolean  "group_license"
    t.integer  "division_id"
  end

  create_table "package_maps", :force => true do |t|
    t.string   "remote_package_id"
    t.string   "service_name"
    t.string   "default_install_task"
    t.string   "default_uninstall_task"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id"
  end

  create_table "packages", :force => true do |t|
    t.string   "manufacturer"
    t.string   "name"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peripherals", :force => true do |t|
    t.integer  "computer_id"
    t.string   "serial_number"
    t.string   "po_number"
    t.string   "division"
    t.string   "model"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",         :default => true, :null => false
    t.integer  "division_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
