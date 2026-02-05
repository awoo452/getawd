module Holdable
  class NormalizeHoldUntil
    def self.call(record)
      new(record).call
    end

    def initialize(record)
      @record = record
    end

    def call
      return if @record.hold_until.blank?

      @record.hold_until = @record.hold_until.in_time_zone.end_of_day
    end
  end
end
