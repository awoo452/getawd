class WorkoutPlansController < ApplicationController
  before_action :set_workout_plan, only: [:update, :destroy]

  def create
    @workout_plan = WorkoutPlan.new(workout_plan_params)
    if @workout_plan.save
      redirect_to workouts_path, notice: "Workout planned."
    else
      redirect_to workouts_path, alert: @workout_plan.errors.full_messages.to_sentence
    end
  end

  def update
    if @workout_plan.update(workout_plan_params.except(:planned_on))
      redirect_to workouts_path, notice: "Workout updated."
    else
      redirect_to workouts_path, alert: @workout_plan.errors.full_messages.to_sentence
    end
  end

  def destroy
    @workout_plan.destroy
    redirect_to workouts_path, notice: "Workout removed."
  end

  private

  def set_workout_plan
    @workout_plan = WorkoutPlan.find(params[:id])
  end

  def workout_plan_params
    params.require(:workout_plan).permit(:planned_on, :workout_type)
  end
end
