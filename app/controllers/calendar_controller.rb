class CalendarController < ApplicationController
  def show
    data = Calendar::ShowData.call(start_date: params[:month])
    @tasks = data.tasks
    @this_months_tasks = data.this_months_tasks
    @calendar_start_date = data.start_date
  end
end
