class CalendarController < ApplicationController
  def daily
    data = Calendar::DailyData.call(start_date: params[:start_date])
    @tasks = data.tasks
    @calendar_start_date = data.start_date
  end

  def monthly
    data = Calendar::MonthlyData.call(start_date: params[:start_date])
    @tasks = data.tasks
  end
end
