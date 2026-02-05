module BlogPosts
  class IndexData
    Result = Struct.new(:blog_posts, :blog_posts_page, :blog_posts_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      blog_posts, blog_posts_page, blog_posts_total_pages =
        @paginator.call(BlogPost.order(created_at: :desc), per_page: 25)

      Result.new(
        blog_posts: blog_posts,
        blog_posts_page: blog_posts_page,
        blog_posts_total_pages: blog_posts_total_pages
      )
    end
  end
end
