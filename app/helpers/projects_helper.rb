module ProjectsHelper
  def project_image_key(filename)
    "projects/#{filename}"
  end

  def project_image_url(filename)
    s3_url(project_image_key(filename))
  end
end
