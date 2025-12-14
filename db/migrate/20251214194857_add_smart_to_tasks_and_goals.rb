class AddSmartToTasksAndGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :smart, :jsonb, default: {}, null: false
    add_column :goals, :smart, :jsonb, default: {}, null: false

  end
end