class WorkoutPlansController < ApplicationController
  before_action :set_workout_plan, only: [:update, :destroy, :toggle_complete]

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
      respond_with_card(@workout_plan)
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to workouts_path, alert: @workout_plan.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @workout_plan.destroy
    redirect_to workouts_path, notice: "Workout removed."
  end

  def toggle_complete
    @workout_plan.update!(completed: !@workout_plan.completed?)
    respond_with_card(@workout_plan)
  end

  private

  def set_workout_plan
    @workout_plan = WorkoutPlan.find(params[:id])
  end

  def workout_plan_params
    params.require(:workout_plan).permit(:planned_on, :workout_type, :notes)
  end

  def respond_with_card(plan)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "workout_day_#{plan.planned_on.iso8601}",
          partial: "workouts/workout_day_card",
          locals: { date: plan.planned_on, plan: plan }
        )
      end
      format.html { redirect_to workouts_path }
    end
  end
end
