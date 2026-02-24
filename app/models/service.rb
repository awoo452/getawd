class Service < ApplicationRecord
  def projects_anchor
    service_type.presence&.parameterize(separator: "_")
  end
end
