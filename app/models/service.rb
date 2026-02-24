class Service < ApplicationRecord
  SERVICE_TYPE_MAP = {
    "AWS Amplify Business Sites" => "amplify_site",
    "Custom Rails Apps" => "custom_rails_app"
  }.freeze
  SERVICE_ANCHOR_MAP = {
    "amplify_site" => "aws_amplify",
    "custom_rails_app" => "custom_rails"
  }.freeze

  def service_type_for_link
    self[:service_type].presence || inferred_service_type
  end

  def projects_anchor
    SERVICE_ANCHOR_MAP[service_type_for_link]
  end

  def self.find_by_service_type(value)
    find_by(service_type: value) || find_by(title: SERVICE_TYPE_MAP.invert[value])
  end

  private

  def inferred_service_type
    return if title.blank?

    normalized = title.downcase
    return "amplify_site" if normalized.include?("amplify")
    return "custom_rails_app" if normalized.include?("rails")

    SERVICE_TYPE_MAP[title]
  end
end
