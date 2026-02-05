class BlogPostsController < ApplicationController
  def index
    data = BlogPosts::IndexData.call(paginator: method(:paginate))
    @blog_posts = data.blog_posts
    @blog_posts_page = data.blog_posts_page
    @blog_posts_total_pages = data.blog_posts_total_pages
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end
end
