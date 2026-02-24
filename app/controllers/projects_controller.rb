class ProjectsController < ApplicationController
  def index
    data = Projects::IndexData.call(paginator: method(:paginate), service_type: params[:service_type])
    @projects = data.projects
    @featured_projects, @other_projects = @projects.partition(&:featured?)
    @projects_page = data.projects_page
    @projects_total_pages = data.projects_total_pages
    @service = Service.find_by(service_type: params[:service_type]) if params[:service_type].present?
  end

  def show
    @project = Project.find(params[:id])
  end
end
