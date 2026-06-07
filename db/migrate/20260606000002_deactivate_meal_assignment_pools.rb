class DeactivateMealAssignmentPools < ActiveRecord::Migration[8.0]
  def up
    meal_goal_ids = execute(
      "SELECT id FROM goals WHERE title IN ('Breakfast', 'Lunch', 'Dinner')"
    ).map { |r| r["id"] }
    return if meal_goal_ids.empty?

    id_list = meal_goal_ids.join(", ")
    execute "UPDATE assignment_pools SET active = false WHERE goal_id IN (#{id_list})"
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
