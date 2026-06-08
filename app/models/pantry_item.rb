class PantryItem < ApplicationRecord
  belongs_to :food_item

  scope :low_stock,   -> { where("servings_on_hand <= min_servings AND servings_on_hand > 0") }
  scope :out_of_stock, -> { where(servings_on_hand: 0) }
  scope :in_stock,    -> { where("servings_on_hand > min_servings") }
  scope :ordered_by_food, -> {
    joins(:food_item).order("food_items.food_type, food_items.position, food_items.name")
  }

  validates :servings_on_hand, numericality: { greater_than_or_equal_to: 0 }
  validates :min_servings,     numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def low? = servings_on_hand <= min_servings && !out?
  def out? = servings_on_hand.zero?

  def derived_servings
    spu = food_item.servings_per_unit
    raw = spu <= 1 ? servings_on_hand : servings_on_hand / spu
    raw % 1 == 0 ? raw.to_i : raw.round(1)
  end

  def stock_status
    return "out" if out?
    return "low" if low?
    "ok"
  end

  def increment!(by = nil)
    by ||= food_item.servings_per_unit
    update!(servings_on_hand: servings_on_hand + by, last_restocked_at: Date.current)
  end

  def decrement!(by = 1)
    update!(servings_on_hand: [servings_on_hand - by, 0].max)
  end

  def set_servings!(amount)
    update!(servings_on_hand: [amount, 0].max, last_restocked_at: Date.current)
  end

  def add_unit!
    update!(servings_on_hand: servings_on_hand + (food_item.unit_servings * food_item.servings_per_unit), last_restocked_at: Date.current)
  end
end
