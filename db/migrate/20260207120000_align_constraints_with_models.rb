class AlignConstraintsWithModels < ActiveRecord::Migration[8.1]
  def up
    # Documents: ensure required fields are present
    execute <<~SQL
      UPDATE documents
      SET title = CONCAT('Untitled Document ', id)
      WHERE title IS NULL OR BTRIM(title) = ''
    SQL

    execute <<~SQL
      UPDATE documents
      SET slug = CONCAT('document-', id)
      WHERE slug IS NULL OR BTRIM(slug) = ''
    SQL

    change_column_null :documents, :title, false
    change_column_null :documents, :slug, false

    # Tasks: backfill required fields before enforcing NOT NULL
    execute <<~SQL
      UPDATE tasks
      SET due_date = COALESCE(completion_date, start_date, created_at::date)
      WHERE due_date IS NULL
    SQL

    execute <<~SQL
      UPDATE tasks
      SET estimated_time = 0
      WHERE estimated_time IS NULL
    SQL

    execute <<~SQL
      UPDATE tasks
      SET actual_time = 0
      WHERE actual_time IS NULL
    SQL

    change_column_null :tasks, :due_date, false
    change_column_null :tasks, :estimated_time, false
    change_column_null :tasks, :actual_time, false

    # Goals: must belong to an idea
    if select_value("SELECT COUNT(*) FROM goals WHERE idea_id IS NULL").to_i > 0
      raise "goals.idea_id has NULLs; populate before adding NOT NULL"
    end

    change_column_null :goals, :idea_id, false

    # Goals: enforce case-insensitive uniqueness by idea
    if select_value(<<~SQL).to_i > 0
      SELECT COUNT(*) FROM (
        SELECT idea_id, LOWER(title) AS lower_title, COUNT(*)
        FROM goals
        WHERE title IS NOT NULL
        GROUP BY idea_id, LOWER(title)
        HAVING COUNT(*) > 1
      ) dupes
    SQL
      raise "Duplicate goal titles (case-insensitive) per idea_id exist; fix before migrating."
    end

    remove_index :goals, name: "index_goals_on_idea_id_and_title"
    add_index :goals, "idea_id, LOWER(title)", unique: true, name: "index_goals_on_idea_id_and_lower_title"

    # Reward tasks: prevent duplicate join rows
    execute <<~SQL
      DELETE FROM reward_tasks a
      USING reward_tasks b
      WHERE a.id > b.id
        AND a.reward_id = b.reward_id
        AND a.task_id = b.task_id
    SQL

    add_index :reward_tasks, [:reward_id, :task_id], unique: true, name: "index_reward_tasks_on_reward_id_and_task_id"
  end

  def down
    remove_index :reward_tasks, name: "index_reward_tasks_on_reward_id_and_task_id"

    remove_index :goals, name: "index_goals_on_idea_id_and_lower_title"
    add_index :goals, [:idea_id, :title], unique: true, name: "index_goals_on_idea_id_and_title"

    change_column_null :goals, :idea_id, true

    change_column_null :tasks, :actual_time, true
    change_column_null :tasks, :estimated_time, true
    change_column_null :tasks, :due_date, true

    change_column_null :documents, :slug, true
    change_column_null :documents, :title, true
  end
end
