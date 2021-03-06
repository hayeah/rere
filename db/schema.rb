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

ActiveRecord::Schema.define(:version => 20100620153232) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "thought_id", :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", :force => true do |t|
    t.integer "follower_id"
    t.integer "followed_id"
  end

  add_index "followings", ["follower_id", "followed_id"], :name => "index_followings_on_follower_id_and_followed_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "groups", ["permalink"], :name => "index_groups_on_permalink", :unique => true

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "memberships", ["group_id", "user_id"], :name => "index_memberships_on_group_id_and_user_id", :unique => true

  create_table "relationships", :force => true do |t|
    t.integer "from_user_id", :null => false
    t.integer "to_user_id",   :null => false
    t.string  "type",         :null => false
  end

  add_index "relationships", ["from_user_id", "to_user_id"], :name => "index_relationships_on_from_user_id_and_to_user_id", :unique => true

  create_table "shared_thoughts", :force => true do |t|
    t.integer "subject_id"
    t.string  "subject_type"
    t.integer "thought_id"
  end

  create_table "stream_thoughts", :force => true do |t|
    t.integer "thought_id"
    t.integer "to_id"
    t.string  "to_type"
    t.integer "from_id"
    t.string  "from_type"
  end

  create_table "thoughts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
