class AssignmentItem < ApplicationRecord

  belongs_to :assignment_pool
  belongs_to :source, polymorphic: true, optional: true
  has_many :assignment_logs, dependent: :destroy

  enum :frequency, {
    daily: "daily",
    weekly: "weekly",
    as_needed: "as_needed"
  }

  scope :active, -> { where(active: true) }

  validates :label, presence: true
  validates :frequency, presence: true
  validates :weight, numericality: { only_integer: true, greater_than: 0 }

end
