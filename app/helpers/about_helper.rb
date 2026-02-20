module AboutHelper
  def about_image_key(filename)
    "about/#{filename}"
  end

  def about_image_url(filename)
    s3_url(about_image_key(filename))
  end
end
