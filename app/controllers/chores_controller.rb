class ChoresController < ApplicationController
  def index
    @week_start = parse_week_start(params[:week_start])
    @week_dates = (0..6).map { |i| @week_start + i.days }
    week_end    = @week_start + 6.days

    plans = ChorePlan.where(planned_on: @week_start..week_end)
    @chore_plans_by_date = plans.group_by(&:planned_on)

    @week_counts     = ChorePlan::TYPES.index_with { |t| plans.count { |p| p.chore_type == t } }
    @week_used_types = ChorePlan::WEEKLY_TYPES.select { |t| @week_counts[t] > 0 }
  end

  private

  def parse_week_start(date_str)
    Date.parse(date_str.to_s).beginning_of_week(:sunday)
  rescue ArgumentError, TypeError
    Time.zone.today.beginning_of_week(:sunday)
  end
end
