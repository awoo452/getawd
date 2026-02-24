module ProjectsHelper
  def project_link_url(url)
    return if url.blank?

    cleaned = url.strip
    return cleaned if cleaned.match?(/\A[a-z][a-z0-9+\-.]*:\/\//i)

    "https://#{cleaned}"
  end

  def project_image_key(filename)
    "projects/#{filename}"
  end

  def project_image_url(filename)
    s3_url(project_image_key(filename))
  end
end
