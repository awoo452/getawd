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

ActiveRecord::Schema[8.1].define(version: 2026_02_25_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "about_sections", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "header", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_about_sections_on_position", unique: true
  end

  create_table "blog_posts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured"
    t.string "image"
    t.bigint "project_id"
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_blog_posts_on_project_id"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.json "body"
    t.datetime "created_at", null: false
    t.json "images"
    t.json "metadata"
    t.string "slug", null: false
    t.json "subheadings"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.json "youtube_id"
    t.index ["slug"], name: "index_documents_on_slug", unique: true
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "body"
    t.string "commit_ref"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.string "section"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.date "completion_date"
    t.datetime "created_at", null: false
    t.string "game_image"
    t.string "game_name"
    t.json "game_notes", default: []
    t.string "game_title"
    t.string "game_type"
    t.jsonb "progress_data", default: {}
    t.boolean "show_to_public", default: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.string "youtube_id"
    t.string "youtube_playlist_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "category"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.string "eligible_reward"
    t.datetime "hold_until"
    t.bigint "idea_id", null: false
    t.integer "priority"
    t.boolean "recurring", default: false
    t.jsonb "smart", default: {}, null: false
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index "idea_id, lower((title)::text)", name: "index_goals_on_idea_id_and_lower_title", unique: true
    t.index ["idea_id"], name: "index_goals_on_idea_id"
    t.check_constraint "status = ANY (ARRAY[0, 1, 2, 3])", name: "goals_status_check"
  end

  create_table "ideas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "landscaping_jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured"
    t.string "image"
    t.string "service_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["service_type"], name: "index_projects_on_service_type"
  end

  create_table "reward_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "params"
    t.bigint "reward_id", null: false
    t.string "rule_type"
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_rules_on_reward_id"
  end

  create_table "reward_tasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "reward_id", null: false
    t.bigint "task_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id", "task_id"], name: "index_reward_tasks_on_reward_id_and_task_id", unique: true
    t.index ["reward_id"], name: "index_reward_tasks_on_reward_id"
    t.index ["task_id"], name: "index_reward_tasks_on_task_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.integer "allowed_duration_days"
    t.boolean "available"
    t.text "completed_reward_notes"
    t.string "completed_reward_url"
    t.integer "cooldown_days"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "goal_id"
    t.string "kind"
    t.date "last_redeemed_at"
    t.string "name"
    t.jsonb "reward_payload", default: {}
    t.string "scope", default: "level", null: false
    t.datetime "updated_at", null: false
    t.index "((reward_payload ->> 'earned_date'::text)), ((reward_payload ->> 'level'::text))", name: "index_rewards_unique_day_level", unique: true, where: "(((scope)::text = 'level'::text) AND ((kind)::text = 'earned'::text))"
    t.index ["goal_id"], name: "index_rewards_on_goal_id"
    t.index ["scope"], name: "index_rewards_on_scope"
  end

  create_table "services", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.boolean "featured", default: false, null: false
    t.string "image"
    t.integer "position", default: 0, null: false
    t.string "service_type"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["service_type"], name: "index_services_on_service_type"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "actual_time", null: false
    t.string "assigned_to"
    t.date "completion_date"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date", null: false
    t.string "eligible_reward"
    t.integer "estimated_time", null: false
    t.bigint "goal_id"
    t.datetime "hold_until"
    t.integer "priority"
    t.jsonb "smart", default: {}, null: false
    t.date "start_date"
    t.integer "status"
    t.string "task_name"
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
    t.check_constraint "status IS NULL OR (status = ANY (ARRAY[0, 1, 2, 3]))", name: "tasks_status_check"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured"
    t.bigint "project_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "youtube_id"
    t.index ["project_id"], name: "index_videos_on_project_id"
  end

  add_foreign_key "blog_posts", "projects"
  add_foreign_key "goals", "ideas"
  add_foreign_key "reward_rules", "rewards"
  add_foreign_key "reward_tasks", "rewards"
  add_foreign_key "reward_tasks", "tasks"
  add_foreign_key "rewards", "goals"
  add_foreign_key "tasks", "goals"
  add_foreign_key "videos", "projects"
end
