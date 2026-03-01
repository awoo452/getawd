class AssignmentLog < ApplicationRecord

  belongs_to :assignment_item
  belongs_to :task

  validates :assigned_on, presence: true
  validates :week_start, presence: true

end
