class AssignmentPool < ApplicationRecord

  belongs_to :goal
  has_many :assignment_items, dependent: :destroy
  has_many :assignment_logs, through: :assignment_items

  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :goal_id, uniqueness: true

end
