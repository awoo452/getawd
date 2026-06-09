class MealPlanRecipe < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :recipe

  after_create  :sync_meal_plan_task
  after_destroy :sync_meal_plan_task

  private

  def sync_meal_plan_task
    meal_plan.task&.update!(task_name: meal_plan.send(:task_label))
  end
end
