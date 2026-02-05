module Home
  class IndexData
    Result = Struct.new(:featured_projects, :featured_blog_posts, :featured_videos, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(
        featured_projects: Project.where(featured: true),
        featured_blog_posts: BlogPost.where(featured: true),
        featured_videos: Video.where(featured: true).order(created_at: :desc)
      )
    end
  end
end
