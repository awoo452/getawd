module Holdable
  class ResumeIfReady
    def self.call(record)
      new(record).call
    end

    def initialize(record)
      @record = record
    end

    def call
      return unless @record.on_hold?
      return unless @record.hold_until.present?
      return unless @record.hold_until <= Time.current

      @record.update!(status: :in_progress, hold_until: nil)
    end
  end
end
