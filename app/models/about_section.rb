# app/models/about_section.rb
class AboutSection < ApplicationRecord
  validates :header, :body, :position, presence: true
  validates :position, uniqueness: true

  scope :ordered, -> { order(:position) }
end
