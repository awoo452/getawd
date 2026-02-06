module DocumentsHelper
  def document_image_url(document, image)
    file = image["file"].to_s
    key = if file == "logo-classic.png"
      "branding/logo-classic.png"
    else
      "documents/#{document.id}/#{file}"
    end
    s3_url(key)
  end
end
