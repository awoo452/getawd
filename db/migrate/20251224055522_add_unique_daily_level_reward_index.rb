class AddUniqueDailyLevelRewardIndex < ActiveRecord::Migration[7.1]
  def change
    execute <<~SQL
      CREATE UNIQUE INDEX index_rewards_unique_day_level
      ON rewards (
        (reward_payload->>'earned_date'),
        (reward_payload->>'level')
      )
      WHERE kind IN ('earned','redeemed');
    SQL
  end
end