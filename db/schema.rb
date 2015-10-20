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

ActiveRecord::Schema.define(version: 20151013061132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_data", force: :cascade do |t|
    t.datetime "gh_last_updated"
    t.datetime "slack_last_updated"
    t.string   "last_slack_ts"
    t.string   "slack_token"
    t.string   "organization"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "date"
    t.string   "author"
    t.text     "body"
    t.string   "repo"
    t.string   "organization"
    t.integer  "number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "commits", force: :cascade do |t|
    t.string   "message"
    t.string   "organization"
    t.string   "author"
    t.string   "sha"
    t.string   "repo"
    t.string   "files_modified"
    t.integer  "additions"
    t.integer  "deletions"
    t.integer  "pr_number"
    t.datetime "date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "issues", force: :cascade do |t|
    t.integer  "number"
    t.string   "repo"
    t.string   "organization"
    t.string   "state"
    t.datetime "closed_at"
    t.string   "title"
    t.text     "body"
    t.string   "author"
    t.datetime "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "avatar_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string   "state"
    t.string   "title"
    t.text     "body"
    t.integer  "number"
    t.datetime "merged_at"
    t.datetime "closed_at"
    t.string   "repo"
    t.string   "organization"
    t.string   "author"
    t.datetime "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.string   "organization"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "slack_githubs", force: :cascade do |t|
    t.string   "github"
    t.string   "slack"
    t.string   "organization"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "slack_messages", force: :cascade do |t|
    t.string   "author"
    t.string   "organization"
    t.text     "text"
    t.datetime "date"
    t.string   "channel"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
