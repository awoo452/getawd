class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feedback, only: [:edit, :update]

  def index
    data = Feedbacks::IndexData.call
    @open_feedback = data.open_feedback
    @completed_feedback = data.completed_feedback
  end

  def new
    @feedback = Feedback.new
  end

  def create
    result = Feedbacks::CreateFeedback.call(params: feedback_params)
    @feedback = result.feedback
    if result.success?
      redirect_to feedbacks_path, notice: "Feedback added"
    else
      render :new
    end
  end

  def edit
  end

  def update
    result = Feedbacks::UpdateFeedback.call(feedback_id: @feedback.id, params: feedback_params)
    @feedback = result.feedback
    if result.success?
      redirect_to feedbacks_path, notice: "Feedback updated"
    else
      render :edit
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(
      :title,
      :body,
      :section,
      :completed,
      :commit_ref
    )
  end
end
