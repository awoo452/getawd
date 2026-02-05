class CalendarController < ApplicationController

  before_action :authenticate_user!

  def show
    data = Calendar::ShowData.call
    @tasks = data.tasks
    @this_months_tasks = data.this_months_tasks
  end
end
