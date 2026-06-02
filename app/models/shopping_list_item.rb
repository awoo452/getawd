class ShoppingListItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :food_item

  scope :unchecked,       -> { where(checked_off: false) }
  scope :checked,         -> { where(checked_off: true) }
  scope :ordered_by_food, -> {
    joins(:food_item).order("food_items.food_type, food_items.name")
  }

  validates :quantity_needed, numericality: { only_integer: true, greater_than: 0 }
  validates :food_item_id, uniqueness: { scope: :shopping_list_id }

  def toggle! = update!(checked_off: !checked_off)
end
