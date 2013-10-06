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

ActiveRecord::Schema.define(:version => 20131006182632) do

  create_table "districts", :force => true do |t|
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "districts", ["stateName", "districtName"], :name => "index_districts_on_stateName_and_districtName", :unique => true

  create_table "entry_points", :force => true do |t|
    t.float    "lattitude",    :null => false
    t.float    "longitude",    :null => false
    t.string   "name",         :null => false
    t.string   "entryType"
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "hotels", :force => true do |t|
    t.float    "lattitude",    :null => false
    t.float    "longitude",    :null => false
    t.string   "name",         :null => false
    t.text     "description"
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "local_transport_stands", :force => true do |t|
    t.float    "lattitude",     :null => false
    t.float    "longitude",     :null => false
    t.string   "name",          :null => false
    t.string   "transportType"
    t.string   "districtName",  :null => false
    t.string   "stateName",     :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "map_points", :force => true do |t|
    t.float    "lattitude",    :null => false
    t.float    "longitude",    :null => false
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "states", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name",       :null => false
  end

  add_index "states", ["name"], :name => "index_states_on_name"

  create_table "tourist_spots", :force => true do |t|
    t.float    "lattitude",    :null => false
    t.float    "longitude",    :null => false
    t.string   "name",         :null => false
    t.float    "rating"
    t.string   "category",     :null => false
    t.text     "description"
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
