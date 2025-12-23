class AllowNullGoalOnRewards < ActiveRecord::Migration[7.1]
  def change
    change_column_null :rewards, :goal_id, true
  end
end