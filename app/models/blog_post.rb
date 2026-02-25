class BlogPost < ApplicationRecord
  belongs_to :project, optional: true

  validates :title, :body, presence: true
end
