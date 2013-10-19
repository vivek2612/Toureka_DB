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

ActiveRecord::Schema.define(:version => 20131015152917) do

  create_table "closer_tos", :force => true do |t|
    t.integer  "local_transport_stand_id"
    t.integer  "tourist_spot_id"
    t.integer  "distance",                 :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "closer_tos", ["local_transport_stand_id", "tourist_spot_id"], :name => "closer_tos_index"

  create_table "closest_hotels", :force => true do |t|
    t.integer  "entry_point_id"
    t.integer  "hotel_id"
    t.integer  "distance",       :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "closest_hotels", ["entry_point_id", "hotel_id"], :name => "closest_hotels_index"

  create_table "districts", :force => true do |t|
    t.integer  "state_id"
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "districts", ["state_id", "name"], :name => "index_districts_on_state_id_and_name"

  create_table "entry_points", :force => true do |t|
    t.float    "latitude",     :null => false
    t.float    "longitude",    :null => false
    t.string   "name",         :null => false
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "entryType"
  end

  create_table "hotels", :force => true do |t|
    t.float    "latitude",     :null => false
    t.float    "longitude",    :null => false
    t.string   "name",         :null => false
    t.text     "description"
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "in_proximity_ofs", :force => true do |t|
    t.integer  "hotel_id"
    t.integer  "tourist_spot_id"
    t.integer  "distance",        :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "in_proximity_ofs", ["hotel_id", "tourist_spot_id"], :name => "index_in_proximity_ofs_on_hotel_id_and_tourist_spot_id"

# Could not dump table "local_transport_stands" because of following StandardError
#   Unknown type 'local_transport_type' for column 'localTransport'

  create_table "map_points", :force => true do |t|
    t.float    "latitude",     :null => false
    t.float    "longitude",    :null => false
    t.string   "districtName", :null => false
    t.string   "stateName",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "near_bies", :force => true do |t|
    t.integer  "hotel_id"
    t.integer  "local_transport_stand_id"
    t.integer  "distance",                 :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "near_bies", ["hotel_id", "local_transport_stand_id"], :name => "index_near_bies_on_hotel_id_and_local_transport_stand_id"

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tourist_spot_id"
    t.text     "review",          :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "states", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name",       :null => false
  end

  add_index "states", ["name"], :name => "index_states_on_name"

# Could not dump table "tourist_spots" because of following StandardError
#   Unknown type 'category_type' for column 'category'

  create_table "trips", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tourist_spot_id"
    t.date     "startDate",       :null => false
    t.integer  "dayNumber",       :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "trips", ["user_id", "startDate"], :name => "index_trips_on_user_id_and_startDate"

# Could not dump table "users" because of following StandardError
#   Unknown type 'role_type' for column 'role'

end
