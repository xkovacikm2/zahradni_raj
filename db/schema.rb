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

ActiveRecord::Schema.define(version: 20170818135926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_countries_on_name", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name",                  null: false
    t.string   "surname",               null: false
    t.string   "company"
    t.string   "ico"
    t.string   "dic"
    t.string   "address",               null: false
    t.string   "email"
    t.string   "phone"
    t.text     "note"
    t.integer  "recruitment_center_id"
    t.integer  "country_id"
    t.integer  "region_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["country_id"], name: "index_customers_on_country_id", using: :btree
    t.index ["recruitment_center_id"], name: "index_customers_on_recruitment_center_id", using: :btree
    t.index ["region_id"], name: "index_customers_on_region_id", using: :btree
  end

  create_table "offer_files", force: :cascade do |t|
    t.string   "stored_filename"
    t.string   "extension"
    t.string   "original_filename"
    t.integer  "offer_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["offer_id"], name: "index_offer_files_on_offer_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.date     "date"
    t.integer  "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_offers_on_request_id", using: :btree
  end

  create_table "recruitment_centers", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_recruitment_centers_on_name", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string  "name"
    t.integer "country_id"
    t.index ["country_id"], name: "index_regions_on_country_id", using: :btree
    t.index ["name"], name: "index_regions_on_name", using: :btree
  end

  create_table "request_categories", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_request_categories_on_name", using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.date     "date"
    t.integer  "customer_id"
    t.integer  "request_categories", default: [],              array: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["customer_id"], name: "index_requests_on_customer_id", using: :btree
  end

  add_foreign_key "customers", "countries"
  add_foreign_key "customers", "recruitment_centers"
  add_foreign_key "customers", "regions"
  add_foreign_key "offer_files", "offers"
  add_foreign_key "offers", "requests"
  add_foreign_key "requests", "customers"
end
