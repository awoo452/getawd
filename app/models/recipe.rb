class Recipe < ApplicationRecord
  MEAL_TYPES = %w[breakfast lunch dinner afternoon_snack bedtime_snack dessert].freeze

  MEAL_TYPE_LABELS = {
    "breakfast"       => "Breakfast",
    "lunch"           => "Lunch",
    "dinner"          => "Dinner",
    "afternoon_snack" => "Afternoon Snack",
    "bedtime_snack"   => "Bedtime Snack",
    "dessert"         => "Dessert"
  }.freeze

  MEAL_TYPE_EMOJI = {
    "breakfast"       => "🌅",
    "lunch"           => "☀️",
    "dinner"          => "🌙",
    "afternoon_snack" => "🌤️",
    "bedtime_snack"   => "🌛",
    "dessert"         => "🍨"
  }.freeze

  has_many :recipe_ingredients, -> { order(:slot_type, :position) }, dependent: :destroy
  has_many :food_items, through: :recipe_ingredients

  scope :active,        -> { where(active: true) }
  scope :ordered,       -> { order(:position, :name) }
  scope :by_meal_type,  ->(type) { where(meal_type_suggestion: type) }

  validates :name,     presence: true
  validates :servings, numericality: { only_integer: true, greater_than: 0 }
  validates :meal_type_suggestion, inclusion: { in: MEAL_TYPES }, allow_blank: true

  def meal_type_label = MEAL_TYPE_LABELS[meal_type_suggestion] || "Any"
  def meal_type_emoji = MEAL_TYPE_EMOJI[meal_type_suggestion]  || "🍽️"

  def can_cook?
    recipe_ingredients.includes(food_item: :pantry_item).all? do |ri|
      ri.food_item.pantry_item&.quantity_on_hand.to_i >= ri.quantity
    end
  end

  def missing_ingredients
    recipe_ingredients.includes(food_item: :pantry_item).select do |ri|
      ri.food_item.pantry_item&.quantity_on_hand.to_i < ri.quantity
    end
  end
end
