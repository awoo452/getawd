class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: %i[ show edit update destroy ]

  # GET /goals or /goals.json
  def index
  scope = Goal.all

  if params[:status].present? && Goal.statuses.key?(params[:status])
    scope = scope.where(status: Goal.statuses[params[:status]])
  end

  if params[:due].present?
    begin
      date = Time.zone.parse(params[:due]).to_date
      scope = scope.where(due_date: date)
    rescue ArgumentError
    end
  end

  scope = scope.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?

  @goals_by_status = {
    in_progress: Goal.in_progress.order(due_date: :asc),
    not_started: Goal.not_started.order(due_date: :asc),
    on_hold: Goal.on_hold.order(due_date: :asc),
    completed: Goal.completed.order(due_date: :asc)
  }
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
    @goal = Goal.new(goal_params)

    respond_to do |format|
      if @goal.save
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
    respond_to do |format|
      if @goal.update(goal_params)
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
    @goal.destroy!

    respond_to do |format|
      format.html { redirect_to goals_path, status: :see_other, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def goal_params
      params.require(:goal).permit(
        :title,
        :description,
        :due_date,
        :priority,
        :category,
        :status,
        :completed_at,
        :idea_id,
        :specific,
        :measurable,
        :attainable,
        :relevant,
        :time_bound
      )
    end
end