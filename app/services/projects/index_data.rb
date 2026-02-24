module Projects
  class IndexData
    Result = Struct.new(:projects, :projects_page, :projects_total_pages, keyword_init: true)

    def self.call(paginator:, service_type: nil)
      new(paginator: paginator, service_type: service_type).call
    end

    def initialize(paginator:, service_type:)
      @paginator = paginator
      @service_type = service_type
    end

    def call
      scope = Project.order(created_at: :desc)
      scope = scope.where(service_type: @service_type) if @service_type.present?

      projects, projects_page, projects_total_pages =
        @paginator.call(scope, per_page: 25)

      Result.new(
        projects: projects,
        projects_page: projects_page,
        projects_total_pages: projects_total_pages
      )
    end
  end
end
