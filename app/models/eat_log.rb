class EatLog < ApplicationRecord
  SLOTS = MealPlan::SLOTS

  belongs_to :prepared_dish, optional: true

  validates :date,      presence: true
  validates :meal_slot, presence: true, inclusion: { in: SLOTS }
  validate  :name_present

  scope :for_week,  ->(start_date) { where(date: start_date..start_date + 6.days) }
  scope :by_slot,   -> { order(:date, :meal_slot) }

  def display_name
    prepared_dish&.name.presence || description.presence || "—"
  end

  private

  def name_present
    errors.add(:base, "must have a dish or description") if prepared_dish_id.blank? && description.blank?
  end
end
