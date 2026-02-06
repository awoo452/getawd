class Goal < ApplicationRecord

  include Holdable

  # SMART (jsonb)
  store_accessor :smart,
    :specific,
    :measurable,
    :attainable,
    :relevant,
    :time_bound

  belongs_to :idea
  has_many :tasks, dependent: :destroy

  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }

  validates :priority,
    numericality: {
      only_integer: true,
      allow_nil: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
  validates :title, uniqueness: {
    scope: :idea_id,
    case_sensitive: false
  }
end
