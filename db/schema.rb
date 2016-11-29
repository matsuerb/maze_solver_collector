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

ActiveRecord::Schema.define(version: 20161128121447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "mazes", force: :cascade do |t|
    t.text     "correct_answer", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["correct_answer"], name: "index_mazes_on_correct_answer", unique: true, using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.integer  "maze_id",      null: false
    t.integer  "solver_id",    null: false
    t.integer  "elapsed_usec", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["solver_id", "maze_id"], name: "index_results_on_solver_id_and_maze_id", unique: true, using: :btree
  end

  create_table "solvers", force: :cascade do |t|
    t.string   "username",               null: false
    t.string   "email",                  null: false
    t.text     "content",                null: false
    t.integer  "nbytes",                 null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "division",   default: 0, null: false
    t.index ["email"], name: "index_solvers_on_email", using: :btree
  end

  add_foreign_key "results", "mazes"
  add_foreign_key "results", "solvers"
end
