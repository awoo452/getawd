class AddRecurringTaskToTasks < ActiveRecord::Migration[8.1]
  def change
    return if column_exists?(:tasks, :recurring_task_id)

    add_reference :tasks, :recurring_task, foreign_key: true
    add_index :tasks, [:recurring_task_id, :due_date]
  end
end
