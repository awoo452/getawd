class Service < ApplicationRecord
  validates :title, :description, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def projects_anchor
    service_type.presence&.parameterize(separator: "_")
  end
end
