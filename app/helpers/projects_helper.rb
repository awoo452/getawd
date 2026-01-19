module ProjectsHelper
  def project_image_url(filename)
    s3_url("projects/#{filename}")
  end
end