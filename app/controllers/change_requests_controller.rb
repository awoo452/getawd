class ChangeRequestsController < ApplicationController
  before_action :set_change_request, only: [:edit, :update]

  def index
    data = ChangeRequests::IndexData.call
    @open_change_requests = data.open_change_requests
    @completed_change_requests = data.completed_change_requests
  end

  def new
    @change_request = ChangeRequest.new
  end

  def create
    result = ChangeRequests::CreateChangeRequest.call(
      params: change_request_params.merge(ip_address: request.remote_ip)
    )
    @change_request = result.change_request
    if result.success?
      redirect_to change_requests_path, notice: "Change request added"
    else
      render :new
    end
  end

  def edit
  end

  def update
    result = ChangeRequests::UpdateChangeRequest.call(
      change_request_id: @change_request.id,
      params: change_request_params
    )
    @change_request = result.change_request
    if result.success?
      redirect_to change_requests_path, notice: "Change request updated"
    else
      render :edit
    end
  end

  private

  def set_change_request
    @change_request = ChangeRequest.find(params[:id])
  end

  def change_request_params
    params.require(:change_request).permit(
      :requester_name,
      :requester_email,
      :summary,
      :details,
      :benefit,
      :acceptance_criteria,
      :priority,
      :status,
      :target_release
    )
  end
end
