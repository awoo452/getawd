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

ActiveRecord::Schema[7.1].define(version: 2025_12_22_201943) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.json "subheadings"
    t.json "body"
    t.json "images"
    t.json "youtube_id"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "game_name"
    t.date "start_date"
    t.date "completion_date"
    t.json "game_notes", default: []
    t.string "game_type"
    t.string "game_image"
    t.string "youtube_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "game_title"
    t.jsonb "progress_data", default: {}
    t.boolean "show_to_public", default: false
    t.string "youtube_playlist_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "due_date"
    t.integer "priority"
    t.string "category"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.bigint "idea_id"
    t.bigint "game_id"
    t.jsonb "smart", default: {}, null: false
    t.datetime "hold_until"
    t.boolean "recurring", default: false
    t.index ["game_id"], name: "index_goals_on_game_id"
    t.index ["idea_id", "title"], name: "index_goals_on_idea_id_and_title", unique: true
    t.index ["idea_id"], name: "index_goals_on_idea_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "landscaping_jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured"
  end

  create_table "reward_rules", force: :cascade do |t|
    t.bigint "reward_id", null: false
    t.string "rule_type"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_rules_on_reward_id"
  end

  create_table "reward_tasks", force: :cascade do |t|
    t.bigint "reward_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_tasks_on_reward_id"
    t.index ["task_id"], name: "index_reward_tasks_on_task_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "goal_id", null: false
    t.integer "cooldown_days"
    t.integer "allowed_duration_days"
    t.date "last_redeemed_at"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "reward_payload", default: {}
    t.index ["goal_id"], name: "index_rewards_on_goal_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "task_name"
    t.text "description"
    t.integer "status"
    t.integer "priority"
    t.date "start_date"
    t.date "due_date"
    t.date "completion_date"
    t.string "assigned_to"
    t.integer "estimated_time"
    t.integer "actual_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "goal_id"
    t.jsonb "smart", default: {}, null: false
    t.datetime "hold_until"
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "youtube_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured"
  end

  add_foreign_key "goals", "games"
  add_foreign_key "goals", "ideas"
  add_foreign_key "reward_rules", "rewards"
  add_foreign_key "reward_tasks", "rewards"
  add_foreign_key "reward_tasks", "tasks"
  add_foreign_key "rewards", "goals"
  add_foreign_key "tasks", "goals"
end
