class LandscapingController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data = Landscaping::IndexData.call
    @LandscapingJobs = data.jobs
  end
end
