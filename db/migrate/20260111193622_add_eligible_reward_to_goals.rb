class AddEligibleRewardToGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :eligible_reward, :string
  end
end
