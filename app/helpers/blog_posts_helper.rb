module BlogPostsHelper
  def blog_post_image_key(filename)
    "blog/#{filename}"
  end

  def blog_post_image_url(filename)
    s3_url(blog_post_image_key(filename))
  end
end
