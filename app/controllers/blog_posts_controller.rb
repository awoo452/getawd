class BlogPostsController < ApplicationController
  def index
    @blog_posts, @blog_posts_page, @blog_posts_total_pages =
      paginate(BlogPost.order(created_at: :desc), per_page: 25)
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end
end
