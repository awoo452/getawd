# app/models/task.rb
class Task < ApplicationRecord
  include Holdable

  store_accessor :smart,
    :specific,
    :measurable,
    :attainable,
    :relevant,
    :time_bound

  belongs_to :goal, optional: true
  has_many :reward_tasks, dependent: :destroy
  has_many :rewards, through: :reward_tasks

  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }

  validates :due_date, presence: true
  validates :estimated_time, numericality: true
  validates :actual_time, numericality: true

  after_update :handle_completion, if: :saved_change_to_status?

  private

  def handle_completion
    return unless completed?

    earn_task_reward
    DailyRewardEarner.run_for_level(priority, earned_on_date)
  end

  def earned_on_date
    completion_date || due_date || Date.current
  end

  def earn_task_reward
    return if eligible_reward.blank?

    already = Reward
      .joins(:reward_tasks)
      .where(scope: "task", reward_tasks: { task_id: id })
      .where("reward_payload ->> 'earned_date' = ?", earned_on_date.to_s)
      .exists?

    return if already

    reward = Reward.create!(
      scope: "task",
      kind: "earned",
      reward_payload: {
        task_id: id,
        goal_id: goal_id,
        level: priority,
        item: eligible_reward,
        earned_date: earned_on_date.to_s
      }
    )

    RewardTask.create!(reward: reward, task: self)
  end

end
