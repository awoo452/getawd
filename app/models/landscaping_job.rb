class LandscapingJob < ApplicationRecord
  validates :title, :description, presence: true
end
