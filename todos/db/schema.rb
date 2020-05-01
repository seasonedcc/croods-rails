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

ActiveRecord::Schema.define(version: 2020_05_01_211743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       :null=>false
    t.string   "slug",       :null=>false, :index=>{:name=>"index_organizations_on_slug", :unique=>true}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               :default=>"email", :null=>false
    t.string   "uid",                    :default=>"", :null=>false, :index=>{:name=>"index_users_on_uid_and_provider", :with=>["provider"], :unique=>true}
    t.string   "encrypted_password",     :default=>"", :null=>false
    t.string   "reset_password_token",   :index=>{:name=>"index_users_on_reset_password_token", :unique=>true}
    t.datetime "reset_password_sent_at"
    t.boolean  "allow_password_change",  :default=>false
    t.datetime "remember_created_at"
    t.string   "confirmation_token",     :index=>{:name=>"index_users_on_confirmation_token", :unique=>true}
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email",                  :null=>false, :index=>{:name=>"index_users_on_email", :unique=>true}
    t.string   "name",                   :null=>false
    t.integer  "age"
    t.text     "bio"
    t.json     "tokens"
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
    t.boolean  "admin",                  :default=>false, :null=>false
    t.boolean  "supervisor",             :default=>false, :null=>false
    t.bigint   "organization_id",        :null=>false, :foreign_key=>{:references=>"organizations", :name=>"fk_users_organization_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__users_organization_id"}
  end

  create_table "projects", force: :cascade do |t|
    t.bigint   "user_id",     :null=>false, :foreign_key=>{:references=>"users", :name=>"fk_projects_user_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__projects_user_id"}
    t.string   "name",        :null=>false
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.boolean  "highlighted", :default=>false, :null=>false
    t.float    "budget"
    t.date     "deadline"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint   "project_id",     :null=>false, :foreign_key=>{:references=>"projects", :name=>"fk_lists_project_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__lists_project_id"}
    t.string   "name",           :null=>false
    t.datetime "created_at",     :null=>false
    t.datetime "updated_at",     :null=>false
    t.integer  "total_tasks",    :default=>0, :null=>false
    t.integer  "finished_tasks", :default=>0, :null=>false
    t.integer  "progress",       :default=>0, :null=>false
    t.string   "status_text"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint   "list_id",    :null=>false, :foreign_key=>{:references=>"lists", :name=>"fk_tasks_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__tasks_list_id"}
    t.string   "name",       :null=>false
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.integer  "sorting"
    t.boolean  "finished",   :default=>false, :null=>false
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint   "task_id",    :null=>false, :foreign_key=>{:references=>"tasks", :name=>"fk_assignments_task_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__assignments_task_id"}
    t.bigint   "user_id",    :null=>false, :foreign_key=>{:references=>"users", :name=>"fk_assignments_user_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__assignments_user_id"}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

end
