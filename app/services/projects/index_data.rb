module Projects
  class IndexData
    Result = Struct.new(:projects, :projects_page, :projects_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      scope = Project.order(created_at: :desc)

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
