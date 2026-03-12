class CalendarController < ApplicationController
  before_action :disable_calendar_cache

  def daily
    data = Calendar::DailyData.call(start_date: params[:start_date])
    @tasks = data.tasks
    @calendar_start_date = data.start_date
    Rails.logger.info("[Calendar] daily start_date_param=#{params[:start_date].inspect} resolved=#{@calendar_start_date.to_date}")
  end

  def monthly
    data = Calendar::MonthlyData.call(start_date: params[:start_date])
    @tasks = data.tasks
    @calendar_start_date = data.start_date
    Rails.logger.info("[Calendar] monthly start_date_param=#{params[:start_date].inspect} resolved=#{@calendar_start_date.to_date}")
  end

  private

  def disable_calendar_cache
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end
end
