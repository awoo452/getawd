class CalendarController < ApplicationController

  before_action :authenticate_user!

  def show
    range = Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
    @tasks = Task.includes(:goal).where(due_date: range)
    @this_months_tasks = @tasks
  end
end
