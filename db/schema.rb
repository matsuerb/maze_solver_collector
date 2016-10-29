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

ActiveRecord::Schema.define(version: 20161031022418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mazes", force: :cascade do |t|
    t.text     "correct_answer", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["correct_answer"], name: "index_mazes_on_correct_answer", unique: true, using: :btree
  end

  create_table "solvers", force: :cascade do |t|
    t.string   "username",     null: false
    t.string   "email",        null: false
    t.text     "content",      null: false
    t.integer  "elapsed_usec", null: false
    t.integer  "nbytes",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["email"], name: "index_solvers_on_email", using: :btree
  end

end
