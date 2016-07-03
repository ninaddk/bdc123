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

ActiveRecord::Schema.define(version: 20160403100104) do

  create_table "activities", force: :cascade do |t|
    t.integer  "activity_type_id",   limit: 4
    t.integer  "student_id",         limit: 4
    t.datetime "time"
    t.string   "comment",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day_care_center_id", limit: 4
  end

  add_index "activities", ["day_care_center_id"], name: "index_activities_on_day_care_center_id", using: :btree

  create_table "day_care_centers", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "day_care_id", limit: 4
    t.string   "address",     limit: 255
    t.string   "zipcode",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_cares", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "zipcode",    limit: 255
    t.string   "url_name",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "day_care_center_id", limit: 4
    t.string   "name",               limit: 255
    t.datetime "due_date"
    t.datetime "reminder_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parent_student_relations", force: :cascade do |t|
    t.integer  "parent_id",             limit: 4
    t.integer  "student_id",            limit: 4
    t.string   "relation_with_student", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parent_student_relations", ["parent_id", "student_id"], name: "index_parent_student_relations_on_parent_id_and_student_id", using: :btree

  create_table "parents", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "username",         limit: 255
    t.string   "password_digest",  limit: 255
    t.string   "email",            limit: 255
    t.string   "contact_number",   limit: 255
    t.string   "address",          limit: 255
    t.string   "zipcode",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id",       limit: 4
    t.string   "rel_with_student", limit: 255
  end

  add_index "parents", ["student_id"], name: "index_parents_on_student_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "day_care_id",              limit: 4
    t.integer  "day_care_center_id",       limit: 4
    t.integer  "classroom_type",           limit: 4
    t.string   "name",                     limit: 255
    t.date     "dob"
    t.datetime "enroll_date"
    t.datetime "activation_date"
    t.datetime "deactivation_date"
    t.string   "primary_contact_number",   limit: 255
    t.string   "preferred_contact_number", limit: 255
    t.datetime "pick_up_time"
    t.string   "food_preference",          limit: 255
    t.string   "ethnicity",                limit: 255
    t.string   "allergies",                limit: 255
    t.string   "medical_conditions",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",          limit: 255
    t.string   "image_content_type",       limit: 255
    t.integer  "image_file_size",          limit: 4
    t.datetime "image_updated_at"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "day_care_id",        limit: 4
    t.integer  "day_care_center_id", limit: 4
    t.integer  "role_id",            limit: 4
    t.integer  "classroom_type",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.string   "password_reset",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
