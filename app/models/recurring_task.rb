# app/models/recurring_task.rb
class RecurringTask < ApplicationRecord
  include Holdable

  store_accessor :smart,
    :specific,
    :measurable,
    :attainable,
    :relevant,
    :time_bound

  belongs_to :goal
  has_many :tasks, dependent: :nullify

  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }

  scope :active, -> { where(active: true) }

  validates :due_date, presence: true
  validates :priority,
    numericality: {
      only_integer: true,
      allow_nil: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
  validates :estimated_time, numericality: true
  validates :actual_time, numericality: true

  after_initialize do
    self.status ||= :not_started
  end

  attr_accessor :recurring, :repeat_until
end
