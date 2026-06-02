class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food_item

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :food_item_id, uniqueness: { scope: :recipe_id }
end
