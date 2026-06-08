class MealPlanItem < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :food_item
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
