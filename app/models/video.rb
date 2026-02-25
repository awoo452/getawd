class Video < ApplicationRecord
  belongs_to :project, optional: true

  validates :title, :youtube_id, presence: true
end
