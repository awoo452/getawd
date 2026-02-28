class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data = Projects::IndexData.call(paginator: method(:paginate))
    @projects = data.projects
    @projects_page = data.projects_page
    @projects_total_pages = data.projects_total_pages
    @services = Service.where.not(service_type: [nil, ""]).order(position: :asc, created_at: :desc)
    @projects_section_copy = Projects::SectionCopy.call
  end

  def show
    @project = Project.find(params[:id])
  end
end
