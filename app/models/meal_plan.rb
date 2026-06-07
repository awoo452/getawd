class MealPlan < ApplicationRecord
  SLOTS = %w[breakfast lunch dinner].freeze

  MEAL_GOAL_TITLES = {
    "breakfast" => "Breakfast",
    "lunch"     => "Lunch",
    "dinner"    => "Dinner"
  }.freeze

  belongs_to :recipe
  belongs_to :task, optional: true

  enum :meal_slot, { breakfast: 0, lunch: 1, dinner: 2 }

  validates :planned_on, presence: true
  validates :meal_slot,  presence: true
  validates :planned_on, uniqueness: { scope: :meal_slot }

  after_create  :generate_task
  before_update :sync_task_name, if: :recipe_id_changed?
  before_destroy :remove_task

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
    "#{meal_slot.capitalize} — #{recipe.name}"
  end

  def meal_goal
    Goal.find_by(title: MEAL_GOAL_TITLES[meal_slot])
  end
end
