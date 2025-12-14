# app/models/concerns/smart_fields.rb
module SmartFields
  extend ActiveSupport::Concern

  SMART_KEYS = %w[specific measurable attainable relevant time_bound]

  SMART_KEYS.each do |key|
    define_method(key) do
      smart[key]
    end

    define_method("#{key}=") do |value|
      self.smart = smart.merge(key => value)
    end
  end
end
