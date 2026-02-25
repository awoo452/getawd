class AddStatusCheckConstraints < ActiveRecord::Migration[8.1]
  def up
    add_check_constraint :tasks, "status IS NULL OR status IN (0, 1, 2, 3)", name: "tasks_status_check"
    add_check_constraint :goals, "status IN (0, 1, 2, 3)", name: "goals_status_check"
  end

  def down
    remove_check_constraint :tasks, name: "tasks_status_check"
    remove_check_constraint :goals, name: "goals_status_check"
  end
end
