module Holdable
  extend ActiveSupport::Concern

  included do
    scope :ready_to_resume, -> {
      on_hold
        .where.not(hold_until: nil)
        .where("hold_until <= ?", Time.current)
    }

    before_save :normalize_hold_until, if: :hold_until_changed?
  end

  def resume_if_ready!
    return unless on_hold?
    return unless hold_until.present?
    return unless hold_until <= Time.current

    update!(status: :in_progress, hold_until: nil)
  end

  private

  def normalize_hold_until
    return if hold_until.blank?

    self.hold_until = hold_until.in_time_zone.end_of_day
  end
end