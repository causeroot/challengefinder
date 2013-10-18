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

ActiveRecord::Schema.define(:version => 20131018050256) do

  create_table "awards", :force => true do |t|
    t.string   "value"
    t.text     "description"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "challenges", :force => true do |t|
    t.string   "url"
    t.datetime "post_date"
    t.string   "image_url"
    t.text     "rules"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "title"
    t.string   "tag_line"
    t.text     "summary"
    t.text     "eligibility"
    t.text     "fee"
    t.string   "sponsor"
    t.text     "contact_info"
    t.string   "topic"
    t.string   "structure"
    t.string   "resultant"
    t.string   "xpath_check"
    t.string   "status"
    t.integer  "numeric_value"
    t.text     "index_deadline"
  end

  create_table "deadlines", :force => true do |t|
    t.datetime "date"
    t.text     "description"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                        :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
