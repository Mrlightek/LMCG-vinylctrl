# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_04_23_185426) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "talent_id", null: false
    t.integer "client_id", null: false
    t.string "status", default: "pending", null: false
    t.string "venue_name", null: false
    t.string "venue_address"
    t.date "event_date", null: false
    t.time "start_time"
    t.time "end_time"
    t.string "event_type"
    t.string "genre"
    t.decimal "agreed_rate", precision: 10, scale: 2
    t.text "notes"
    t.text "client_notes"
    t.string "reference"
    t.boolean "contract_signed", default: false
    t.boolean "invoice_paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "event_date"], name: "index_bookings_on_client_id_and_event_date"
    t.index ["client_id"], name: "index_bookings_on_client_id"
    t.index ["event_date"], name: "index_bookings_on_event_date"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["talent_id", "event_date"], name: "index_bookings_on_talent_id_and_event_date"
    t.index ["talent_id"], name: "index_bookings_on_talent_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gigs", force: :cascade do |t|
    t.integer "posted_by_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "venue_name"
    t.string "venue_city"
    t.string "venue_state"
    t.date "event_date"
    t.time "start_time"
    t.time "end_time"
    t.json "genres", default: []
    t.decimal "budget", precision: 10, scale: 2
    t.string "status", default: "open"
    t.date "application_deadline"
    t.boolean "featured", default: false
    t.integer "views_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_gigs_on_event_date"
    t.index ["posted_by_id"], name: "index_gigs_on_posted_by_id"
    t.index ["status"], name: "index_gigs_on_status"
  end

  create_table "landing_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "slug", null: false
    t.string "bio_name"
    t.text "bio"
    t.string "tagline"
    t.integer "hourly_rate"
    t.json "genres", default: []
    t.string "equipment"
    t.string "website"
    t.string "instagram"
    t.string "soundcloud"
    t.string "youtube"
    t.boolean "published", default: false
    t.boolean "available", default: true
    t.boolean "featured", default: false
    t.float "average_rating", default: 0.0
    t.integer "total_bookings", default: 0
    t.json "settings", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["available"], name: "index_profiles_on_available"
    t.index ["average_rating"], name: "index_profiles_on_average_rating"
    t.index ["published"], name: "index_profiles_on_published"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "user_type", default: "dj", null: false
    t.string "phone"
    t.string "city"
    t.string "state"
    t.string "plan", default: "free"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["user_type"], name: "index_users_on_user_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "users", column: "client_id"
  add_foreign_key "bookings", "users", column: "talent_id"
  add_foreign_key "gigs", "users", column: "posted_by_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "sessions", "users"
end
