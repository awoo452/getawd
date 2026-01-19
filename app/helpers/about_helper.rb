module AboutHelper
  def about_image_url(filename)
    s3_url("about/#{filename}")
  end
end
