class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: %i[ show edit update destroy ]

  # GET /goals or /goals.json
  def index
    result = Goals::IndexData.call(params: params)
    @goals_by_status = result.goals_by_status
    flash.now[:alert] = "Invalid filters: #{result.errors.join(', ')}" if result.errors.any?
  end


  # GET /goals/1 or /goals/1.json
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals or /goals.json
  def create
    result = Goals::CreateGoal.call(params: goal_params)
    @goal = result.goal

    respond_to do |format|
      if result.success?
        format.html { redirect_to @goal, notice: "Goal was successfully created." }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1 or /goals/1.json
  def update
    result = Goals::UpdateGoal.call(goal_id: @goal.id, params: goal_params)
    @goal = result.goal
    respond_to do |format|
      if result.success?
        format.html { redirect_to @goal, notice: "Goal was successfully updated." }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1 or /goals/1.json
  def destroy
    Goals::DestroyGoal.call(goal_id: @goal.id)

    respond_to do |format|
      format.html { redirect_to goals_path, status: :see_other, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(
      :title,
      :description,
      :due_date,
      :priority,
      :category,
      :idea_id,
      :status,
      :recurring,
      :hold_until,
      :completed_at,
      :specific,
      :measurable,
      :attainable,
      :relevant,
      :time_bound
    )
  end

end
