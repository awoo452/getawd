module Videos
  class IndexData
    Result = Struct.new(:videos, :videos_page, :videos_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      videos, videos_page, videos_total_pages =
        @paginator.call(Video.order(created_at: :desc), per_page: 25)

      Result.new(
        videos: videos,
        videos_page: videos_page,
        videos_total_pages: videos_total_pages
      )
    end
  end
end
