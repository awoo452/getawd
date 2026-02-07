module Params
  module Normalize
    module_function

    def string(value)
      value.to_s.strip.presence
    end

    def integer(value)
      return nil if value.blank?

      Integer(value, 10)
    rescue ArgumentError, TypeError
      nil
    end

    def date(value)
      return nil if value.blank?

      Time.zone.parse(value.to_s).to_date
    rescue ArgumentError, TypeError
      nil
    end

    def enum(value, allowed)
      key = string(value)
      return nil unless key && allowed.key?(key)

      key
    end

    def sort_column(value, allowed)
      column = string(value)
      return nil unless column && allowed.include?(column)

      column
    end
  end
end
