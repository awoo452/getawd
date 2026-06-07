class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food_item

  before_validation :set_slot_type

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :food_item_id, uniqueness: { scope: :recipe_id }

  private

  def set_slot_type
    self.slot_type = food_item&.food_type if slot_type.blank?
  end
end
