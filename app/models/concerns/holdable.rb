module Holdable
  extend ActiveSupport::Concern

  included do
    scope :ready_to_resume, -> {
      on_hold.where.not(hold_until: nil)
             .where("hold_until <= ?", Time.current)
    }
  end

  def resume_if_ready!
    return unless on_hold?
    return unless hold_until.present?
    return unless hold_until <= Time.current

    update!(status: :in_progress, hold_until: nil)
  end
end
