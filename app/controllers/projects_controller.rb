class ProjectsController < ApplicationController
  def index
    data = Projects::IndexData.call(paginator: method(:paginate))
    @projects = data.projects
    @projects_page = data.projects_page
    @projects_total_pages = data.projects_total_pages
  end
end
