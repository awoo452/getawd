class RewardTask < ApplicationRecord
  belongs_to :reward
  belongs_to :task

  validates :reward_id, uniqueness: { scope: :task_id }
end
