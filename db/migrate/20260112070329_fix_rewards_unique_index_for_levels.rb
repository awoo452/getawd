class FixRewardsUniqueIndexForLevels < ActiveRecord::Migration[7.1]
  def change
    remove_index :rewards, name: "index_rewards_unique_day_level"

    execute <<~SQL
      CREATE UNIQUE INDEX index_rewards_unique_day_level
      ON rewards (
        (reward_payload->>'earned_date'),
        (reward_payload->>'level')
      )
      WHERE scope = 'level' AND kind = 'earned';
    SQL
  end
end
