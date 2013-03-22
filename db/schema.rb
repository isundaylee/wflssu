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

ActiveRecord::Schema.define(:version => 20130322080236) do

  create_table "attendences", :force => true do |t|
    t.integer  "event_id"
    t.integer  "member_id"
    t.integer  "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "memo"
    t.date     "on_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.integer  "admission_year"
    t.integer  "class_number"
    t.integer  "phone_number"
    t.string   "email"
    t.integer  "gender"
    t.integer  "qq"
    t.date     "birthday"
    t.integer  "department_id"
    t.string   "secondary_school"
    t.integer  "code_number"
    t.text     "memo"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "privilege"
  end

  create_table "notifications", :force => true do |t|
    t.text     "content"
    t.string   "link"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shortlogs", :force => true do |t|
    t.text     "content"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
