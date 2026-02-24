class Project < ApplicationRecord
  has_many :videos, dependent: :nullify
  has_many :blog_posts, dependent: :nullify
end
