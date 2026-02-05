module LandscapingHelper
  def landscaping_image_url(filename)
    s3_url("landscaping/#{filename}")
  end
end
