class ProjectsController < ApplicationController
  def index
    @projects, @projects_page, @projects_total_pages =
      paginate(Project.order(created_at: :desc), per_page: 25)
  end
end
