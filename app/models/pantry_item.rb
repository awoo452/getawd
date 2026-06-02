class PantryItem < ApplicationRecord
  belongs_to :food_item

  scope :low_stock,   -> { where("quantity_on_hand <= min_quantity") }
  scope :out_of_stock, -> { where(quantity_on_hand: 0) }
  scope :in_stock,    -> { where("quantity_on_hand > min_quantity") }
  scope :ordered_by_food, -> {
    joins(:food_item).order("food_items.food_type, food_items.position, food_items.name")
  }

  validates :quantity_on_hand, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :min_quantity,     numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def low? = quantity_on_hand <= min_quantity
  def out? = quantity_on_hand.zero?

  def stock_status
    return "out" if out?
    return "low" if low?
    "ok"
  end

  def increment!(by = 1)
    update!(quantity_on_hand: quantity_on_hand + by, last_restocked_at: Date.current)
  end

  def decrement!(by = 1)
    update!(quantity_on_hand: [quantity_on_hand - by, 0].max)
  end
end
