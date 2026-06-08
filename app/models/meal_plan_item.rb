class MealPlanItem < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :food_item
end
