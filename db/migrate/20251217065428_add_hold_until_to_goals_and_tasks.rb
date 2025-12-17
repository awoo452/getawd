class AddHoldUntilToGoalsAndTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :hold_until, :datetime
    add_column :tasks, :hold_until, :datetime
  end
end