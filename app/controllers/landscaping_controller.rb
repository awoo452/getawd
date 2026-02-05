class LandscapingController < ApplicationController
  def index
    data = Landscaping::IndexData.call
    @LandscapingJobs = data.jobs
  end
end
