class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feedback, only: [:edit, :update]

  def index
    @open_feedback     = Feedback.open.order(created_at: :desc)
    @completed_feedback = Feedback.completed.order(updated_at: :desc)
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to feedbacks_path, notice: "Feedback added"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @feedback.update(feedback_params)
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
