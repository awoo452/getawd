class Bug < ApplicationRecord
  SEVERITIES = %w[low medium high critical].freeze
  STATUSES = %w[new triaged in_progress resolved wont_fix].freeze

  validates :reporter_name, :reporter_email, :summary, :details, presence: true
  validates :severity, inclusion: { in: SEVERITIES }
  validates :status, inclusion: { in: STATUSES }

  scope :open, -> { where(status: %w[new triaged in_progress]) }
  scope :completed, -> { where(status: %w[resolved wont_fix]) }
end
