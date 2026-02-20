module LandscapingHelper
  def landscaping_image_key(filename)
    "landscaping/#{filename}"
  end

  def landscaping_image_url(filename)
    s3_url(landscaping_image_key(filename))
  end
end
