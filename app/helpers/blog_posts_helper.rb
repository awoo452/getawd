module BlogPostsHelper
  def blog_post_image_url(filename)
    s3_url("blog_posts/#{filename}")
  end
end