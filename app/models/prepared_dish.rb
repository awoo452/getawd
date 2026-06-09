class PreparedDish < ApplicationRecord
  belongs_to :recipe,    optional: true
  belongs_to :meal_plan, optional: true
  has_many :eat_logs, dependent: :nullify

  validates :name,               presence: true
  validates :cooked_on,          presence: true
  validates :servings_remaining, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active,   -> { where("servings_remaining > 0") }
  scope :by_date,  -> { order(cooked_on: :desc, created_at: :desc) }

  def consume_one!
    decrement!(:servings_remaining) if servings_remaining > 0
  end
end
