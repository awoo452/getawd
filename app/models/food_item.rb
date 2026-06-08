class FoodItem < ApplicationRecord
  FOOD_TYPES = %w[protein vegetable fruit side sauce snack dessert].freeze
  LOCATIONS  = %w[fridge freezer cupboard].freeze
  UNITS      = %w[each can bag box pack jar bottle loaf container jug kit].freeze

  FOOD_TYPE_LABELS = {
    "protein"   => "Protein",
    "vegetable" => "Vegetable",
    "fruit"     => "Fruit",
    "side"      => "Side",
    "sauce"     => "Sauce / Condiment",
    "snack"     => "Snack",
    "dessert"   => "Dessert"
  }.freeze

  FOOD_TYPE_EMOJI = {
    "protein"   => "🍗",
    "vegetable" => "🥦",
    "fruit"     => "🍎",
    "side"      => "🍞",
    "sauce"     => "🫙",
    "snack"     => "🍿",
    "dessert"   => "🍨"
  }.freeze

  LOCATION_LABELS = {
    "fridge"   => "Fridge",
    "freezer"  => "Freezer",
    "cupboard" => "Cupboard"
  }.freeze

  has_one  :pantry_item, dependent: :destroy

  after_create :create_pantry_item
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :shopping_list_items, dependent: :destroy

  scope :active,  -> { where(active: true) }
  scope :by_type, ->(type) { where(food_type: type) }
  scope :ordered, -> { order(:position, :name) }

  validates :name,             presence: true
  validates :food_type,        inclusion: { in: FOOD_TYPES }
  validates :location,         inclusion: { in: LOCATIONS }
  validates :unit,             inclusion: { in: UNITS }
  validates :position,         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :servings_per_unit, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def type_label    = FOOD_TYPE_LABELS[food_type]  || food_type.humanize
  def type_emoji    = FOOD_TYPE_EMOJI[food_type]   || "🍽️"
  def location_label = LOCATION_LABELS[location]   || location.humanize

  private

  def create_pantry_item
    PantryItem.create!(food_item: self, quantity_on_hand: 0, min_quantity: 1, servings_on_hand: 0, min_servings: 1)
  end
end
