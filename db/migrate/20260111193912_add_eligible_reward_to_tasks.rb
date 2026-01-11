class AddEligibleRewardToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :eligible_reward, :string
  end
end
