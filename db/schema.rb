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

ActiveRecord::Schema.define(version: 20160123140702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "site"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_infos", force: :cascade do |t|
    t.integer  "lead_id"
    t.string   "mobile_phone"
    t.string   "personal_phone"
    t.string   "twitter"
    t.string   "facebook"
    t.text     "linkedin"
    t.text     "website"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "lead_infos", ["lead_id"], name: "index_lead_infos_on_lead_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "job_title"
    t.text     "bio"
    t.boolean  "opportunity"
    t.boolean  "available_for_mailing"
    t.integer  "conversion_sum"
    t.integer  "company_id"
    t.integer  "city_id"
    t.integer  "state_id"
    t.string   "tags"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "leads", ["city_id"], name: "index_leads_on_city_id", using: :btree
  add_index "leads", ["company_id"], name: "index_leads_on_company_id", using: :btree
  add_index "leads", ["state_id"], name: "index_leads_on_state_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cities", "states"
  add_foreign_key "lead_infos", "leads"
  add_foreign_key "leads", "cities"
  add_foreign_key "leads", "companies"
  add_foreign_key "leads", "states"
end
