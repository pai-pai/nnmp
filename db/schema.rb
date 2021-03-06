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

ActiveRecord::Schema.define(:version => 20140407181119) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "candidates", :force => true do |t|
    t.string   "fam_name"
    t.string   "first_name"
    t.string   "sec_name"
    t.integer  "nomination_id"
    t.integer  "org_id"
    t.integer  "unit_id"
    t.string   "depart"
    t.string   "ward"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "candidates", ["nomination_id"], :name => "index_candidates_on_nomination_id"
  add_index "candidates", ["org_id"], :name => "index_candidates_on_org_id"
  add_index "candidates", ["unit_id"], :name => "index_candidates_on_unit_id"

  create_table "nominations", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
  end

  create_table "orgs", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
  end

  add_index "orgs", ["area_id"], :name => "index_orgs_on_area_id"

  create_table "units", :force => true do |t|
    t.string   "name"
    t.integer  "org_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "units", ["org_id"], :name => "index_units_on_org_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "remember_token"
    t.boolean  "admin",          :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.text     "comment",      :limit => 255
    t.string   "voter_fio"
    t.string   "voter_phone"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "measures"
  end

  add_index "votes", ["candidate_id"], :name => "index_votes_on_candidate_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
