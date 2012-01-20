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

ActiveRecord::Schema.define(:version => 20120117181643) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "nodes", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8,                             :null => false
    t.integer  "version",                                               :null => false
    t.integer  "user_id",                                               :null => false
    t.datetime "tstamp",                                                :null => false
    t.integer  "changeset_id", :limit => 8,                             :null => false
    t.hstore   "tags"
    t.spatial  "geom",         :limit => {:srid=>4326, :type=>"point"}
  end

  add_index "nodes", ["geom"], :name => "idx_nodes_geom", :spatial => true

  create_table "project_nodes", :force => true do |t|
    t.integer  "project_id",                                            :null => false
    t.integer  "osm_id",       :limit => 8,                             :null => false
    t.integer  "version",                                               :null => false
    t.integer  "user_id",                                               :null => false
    t.datetime "tstamp",                                                :null => false
    t.integer  "changeset_id", :limit => 8,                             :null => false
    t.hstore   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",         :limit => {:srid=>4326, :type=>"point"}
    t.text     "status"
  end

  create_table "project_relation_members", :force => true do |t|
    t.integer "project_id",               :null => false
    t.integer "relation_id", :limit => 8, :null => false
    t.integer "member_id",   :limit => 8, :null => false
    t.string  "member_type", :limit => 1, :null => false
    t.text    "member_role",              :null => false
    t.integer "sequence_id",              :null => false
  end

  create_table "project_relations", :force => true do |t|
    t.integer  "project_id",                :null => false
    t.integer  "osm_id",       :limit => 8, :null => false
    t.integer  "version",                   :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "tstamp",                    :null => false
    t.integer  "changeset_id", :limit => 8, :null => false
    t.hstore   "tags"
    t.text     "status"
  end

  create_table "project_users", :force => true do |t|
    t.integer "project_id", :null => false
    t.integer "osm_id",     :null => false
    t.text    "name",       :null => false
  end

  create_table "project_way_nodes", :force => true do |t|
    t.integer "project_id",               :null => false
    t.integer "way_id",      :limit => 8, :null => false
    t.integer "node_id",     :limit => 8, :null => false
    t.integer "sequence_id",              :null => false
  end

  create_table "project_ways", :force => true do |t|
    t.integer  "project_id",                :null => false
    t.integer  "osm_id",       :limit => 8
    t.integer  "version",                   :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "tstamp",                    :null => false
    t.integer  "changeset_id", :limit => 8, :null => false
    t.hstore   "tags"
    t.text     "status"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.boolean  "loaded",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relation_members", :id => false, :force => true do |t|
    t.integer "relation_id", :limit => 8, :null => false
    t.integer "member_id",   :limit => 8, :null => false
    t.string  "member_type", :limit => 1, :null => false
    t.text    "member_role",              :null => false
    t.integer "sequence_id",              :null => false
  end

  add_index "relation_members", ["member_id", "member_type"], :name => "idx_relation_members_member_id_and_type"

  create_table "relations", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8, :null => false
    t.integer  "version",                   :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "tstamp",                    :null => false
    t.integer  "changeset_id", :limit => 8, :null => false
    t.hstore   "tags"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version", :null => false
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.text    "name", :null => false
  end

  create_table "way_nodes", :id => false, :force => true do |t|
    t.integer "way_id",      :limit => 8, :null => false
    t.integer "node_id",     :limit => 8, :null => false
    t.integer "sequence_id",              :null => false
  end

  add_index "way_nodes", ["node_id"], :name => "idx_way_nodes_node_id"

  create_table "ways", :id => false, :force => true do |t|
    t.integer  "id",           :limit => 8, :null => false
    t.integer  "version",                   :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "tstamp",                    :null => false
    t.integer  "changeset_id", :limit => 8, :null => false
    t.hstore   "tags"
    t.string   "nodes",        :limit => 8
  end

end
