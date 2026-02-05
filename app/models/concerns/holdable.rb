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
    Holdable::ResumeIfReady.call(self)
  end

  private

  def normalize_hold_until
    Holdable::NormalizeHoldUntil.call(self)
  end
end
