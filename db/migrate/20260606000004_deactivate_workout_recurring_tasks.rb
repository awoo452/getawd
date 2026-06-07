class DeactivateWorkoutRecurringTasks < ActiveRecord::Migration[8.0]
  GOAL_TITLES = %w[Breakfast Lunch Dinner Cardio Strength\ Training].freeze

  def up
    goal_ids = execute(
      "SELECT id FROM goals WHERE title IN ('Breakfast','Lunch','Dinner','Cardio','Strength Training')"
    ).map { |r| r["id"] }
    return if goal_ids.empty?

    id_list = goal_ids.join(", ")

    execute "UPDATE recurring_tasks SET active = false WHERE goal_id IN (#{id_list})"

    execute <<~SQL
      DELETE FROM assignment_logs
        WHERE task_id IN (
          SELECT id FROM tasks WHERE goal_id IN (#{id_list}) AND status IN (0, 1)
        )
    SQL

    execute "DELETE FROM tasks WHERE goal_id IN (#{id_list}) AND status IN (0, 1)"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
