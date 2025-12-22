class AddRewardPayloadToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :reward_payload, :jsonb, default: {}
  end
end
