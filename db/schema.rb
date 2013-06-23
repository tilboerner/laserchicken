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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130622195803) do

  create_table "entries", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["feed_id"], name: "index_entries_on_feed_id"

  create_table "feeds", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "feed_url"
    t.string   "etag"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["feed_id"], name: "index_subscriptions_on_feed_id"
  add_index "subscriptions", ["user_id", "feed_id"], name: "index_subscriptions_on_user_id_and_feed_id", unique: true
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "user_states", force: true do |t|
    t.integer  "entry_id"
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.boolean  "seen"
    t.boolean  "starred"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_states", ["entry_id"], name: "index_user_states_on_entry_id"
  add_index "user_states", ["subscription_id"], name: "index_user_states_on_subscription_id"
  add_index "user_states", ["user_id"], name: "index_user_states_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true

end
