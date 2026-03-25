class BugsController < ApplicationController
  before_action :set_bug, only: [:edit, :update]

  def index
    data = Bugs::IndexData.call
    @open_bugs = data.open_bugs
    @completed_bugs = data.completed_bugs
  end

  def new
    @bug = Bug.new
  end

  def create
    result = Bugs::CreateBug.call(params: bug_params.merge(ip_address: request.remote_ip))
    @bug = result.bug
    if result.success?
      redirect_to bugs_path, notice: "Bug added"
    else
      render :new
    end
  end

  def edit
  end

  def update
    result = Bugs::UpdateBug.call(bug_id: @bug.id, params: bug_params)
    @bug = result.bug
    if result.success?
      redirect_to bugs_path, notice: "Bug updated"
    else
      render :edit
    end
  end

  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(
      :reporter_name,
      :reporter_email,
      :summary,
      :details,
      :steps_to_reproduce,
      :expected_behavior,
      :actual_behavior,
      :severity,
      :status,
      :environment
    )
  end
end
