# app/models/about_section.rb
class AboutSection < ApplicationRecord
  validates :header, :body, :position, presence: true
  default_scope { order(:position) }
end
