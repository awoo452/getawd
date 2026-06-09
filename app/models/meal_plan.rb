class MealPlan < ApplicationRecord
  SLOTS = %w[breakfast lunch dinner].freeze

  MEAL_GOAL_TITLES = {
    "breakfast" => "Breakfast",
    "lunch"     => "Lunch",
    "dinner"    => "Dinner"
  }.freeze

  belongs_to :task, optional: true
  has_many :meal_plan_recipes, dependent: :destroy
  has_many :recipes, through: :meal_plan_recipes
  has_many :meal_plan_items, dependent: :destroy
  has_many :food_items, through: :meal_plan_items
  has_many :prepared_dishes, dependent: :destroy

  enum :meal_slot, { breakfast: 0, lunch: 1, dinner: 2 }

  validates :planned_on, presence: true
  validates :meal_slot,  presence: true
  validates :planned_on, uniqueness: { scope: :meal_slot }

  after_create  :generate_task
  after_update  :sync_cooked_to_task,          if: :saved_change_to_cooked?
  after_update  :sync_cooked_to_prepared_dish, if: :saved_change_to_cooked?
  before_destroy :remove_task

  def deduct_inventory!
    recipes.includes(recipe_ingredients: :food_item).each do |r|
      r.recipe_ingredients.each do |ri|
        ri.food_item.pantry_item&.decrement!(ri.quantity * ri.food_item.servings_per_unit)
      end
    end
    meal_plan_items.includes(food_item: :pantry_item).each do |item|
      item.food_item.pantry_item&.decrement!(item.quantity * item.food_item.servings_per_unit)
    end
  end

  def restore_inventory!
    recipes.includes(recipe_ingredients: :food_item).each do |r|
      r.recipe_ingredients.each do |ri|
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

  def sync_cooked_to_task
    if cooked?
      task&.update!(status: :completed, completion_date: planned_on)
    else
      task&.update!(status: :not_started, completion_date: nil)
    end
  end

  def sync_cooked_to_prepared_dish
    if cooked?
      if recipes.any?
        recipes.each do |r|
          PreparedDish.create!(
            name:               r.name,
            servings_remaining: r.servings,
            cooked_on:          planned_on,
            recipe_id:          r.id,
            meal_plan_id:       id
          )
        end
      end
      if meal_plan_items.any?
        PreparedDish.create!(
          name:               "#{meal_slot.capitalize} — Custom Items",
          servings_remaining: 1,
          cooked_on:          planned_on,
          recipe_id:          nil,
          meal_plan_id:       id
        )
      end
    else
      prepared_dishes.destroy_all
    end
  end

  def remove_task
    task&.destroy
    self.task_id = nil
  end

  def task_label
    recipe_names = recipes.map(&:name).presence
    "#{meal_slot.capitalize} — #{recipe_names&.join(', ') || 'Custom Meal'}"
  end

  def meal_goal
    Goal.find_by(title: MEAL_GOAL_TITLES[meal_slot])
  end
end
