module Home
  class IndexData
    Result = Struct.new(
      :featured_projects,
      :featured_blog_posts,
      :featured_videos,
      :featured_services,
      keyword_init: true
    )

    def self.call
      new.call
    end

    def call
      Result.new(
        featured_projects: Project.where(featured: true),
        featured_blog_posts: BlogPost.where(featured: true),
        featured_videos: Video.where(featured: true).order(created_at: :desc),
        featured_services: Service.where(featured: true).order(position: :asc, created_at: :desc)
      )
    end
  end
end
