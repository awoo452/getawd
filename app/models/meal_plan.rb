class MealPlan < ApplicationRecord
  SLOTS = %w[breakfast lunch dinner].freeze

  MEAL_GOAL_TITLES = {
    "breakfast" => "Breakfast",
    "lunch"     => "Lunch",
    "dinner"    => "Dinner"
  }.freeze

  belongs_to :recipe, optional: true
  belongs_to :task, optional: true
  has_many :meal_plan_items, dependent: :destroy
  has_many :food_items, through: :meal_plan_items

  enum :meal_slot, { breakfast: 0, lunch: 1, dinner: 2 }

  validates :planned_on, presence: true
  validates :meal_slot,  presence: true
  validates :planned_on, uniqueness: { scope: :meal_slot }

  after_create  :generate_task
  before_update :sync_task_name, if: :recipe_id_changed?
  before_destroy :remove_task

  def deduct_inventory!
    if recipe
      recipe.recipe_ingredients.includes(food_item: :pantry_item).each do |ri|
        ri.food_item.pantry_item&.decrement!(ri.quantity * ri.food_item.servings_per_unit)
      end
    end
    meal_plan_items.includes(food_item: :pantry_item).each do |item|
      item.food_item.pantry_item&.decrement!(item.quantity * item.food_item.servings_per_unit)
    end
  end

  def restore_inventory!
    if recipe
      recipe.recipe_ingredients.includes(food_item: :pantry_item).each do |ri|
        ri.food_item.pantry_item&.increment!(ri.quantity * ri.food_item.servings_per_unit)
      end
    end
    meal_plan_items.includes(food_item: :pantry_item).each do |item|
      item.food_item.pantry_item&.increment!(item.quantity * item.food_item.servings_per_unit)
    end
  end

  private

  def generate_task
    t = Task.create!(
      task_name:      task_label,
      goal:           meal_goal,
      due_date:       planned_on,
      start_date:     planned_on,
      priority:       1,
      estimated_time: 15,
      actual_time:    0,
      status:         :not_started
    )
    update_column(:task_id, t.id)
  end

  def sync_task_name
    task&.update!(task_name: task_label)
  end

  def remove_task
    task&.destroy
    self.task_id = nil
  end

  def task_label
    "#{meal_slot.capitalize} — #{recipe&.name || 'Custom Meal'}"
  end

  def meal_goal
    Goal.find_by(title: MEAL_GOAL_TITLES[meal_slot])
  end
end
