module Services
  class IndexData
    Result = Struct.new(:services, :services_page, :services_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      services, services_page, services_total_pages =
        @paginator.call(Service.order(position: :asc, created_at: :desc), per_page: 25)

      Result.new(
        services: services,
        services_page: services_page,
        services_total_pages: services_total_pages
      )
    end
  end
end
