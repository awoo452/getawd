class Task < ApplicationRecord
  # SMART (jsonb)
  store_accessor :smart,
    :specific,
    :measurable,
    :attainable,
    :relevant,
    :time_bound

  belongs_to :goal, optional: true
  has_many :reward_tasks, dependent: :destroy
  has_many :rewards, through: :reward_tasks

  enum status: {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }

  validates :due_date, presence: true
  validates :estimated_time, numericality: true
  validates :actual_time, numericality: true
end