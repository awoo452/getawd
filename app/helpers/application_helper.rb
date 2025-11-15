module ApplicationHelper

    def app_logo_url
        "https://getawd-prod.s3.us-west-1.amazonaws.com/branding/logo.png"
    end

    def about_image_url(num)
        "https://getawd-prod.s3.us-west-1.amazonaws.com/about/about#{num}.png"
    end

    def blog_image_url(filename)
    return "https://getawd-prod.s3.us-west-1.amazonaws.com/branding/logo.png" if filename == "logo.png"
    "https://getawd-prod.s3.us-west-1.amazonaws.com/blog/#{filename}"
    end

    def branding_image_url(filename)
      "https://getawd-prod.s3.us-west-1.amazonaws.com/branding/#{filename}"
    end

    def landscaping_image_url(filename)
      "https://getawd-prod.s3.us-west-1.amazonaws.com/landscaping/#{filename}"
    end

    def project_image_url(filename)
    return "https://getawd-prod.s3.us-west-1.amazonaws.com/branding/logo.png" if filename == "logo.png"
    "https://getawd-prod.s3.us-west-1.amazonaws.com/projects/#{filename}"
    end


end