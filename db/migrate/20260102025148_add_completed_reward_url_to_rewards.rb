class AddCompletedRewardUrlToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :completed_reward_url, :string
    add_column :rewards, :completed_reward_notes, :text
  end
end
