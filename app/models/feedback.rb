class Feedback < ApplicationRecord
  validates :title, presence: true

  scope :open, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
