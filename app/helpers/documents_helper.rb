module DocumentsHelper
  def document_image_key(document, image)
    file = image["file"].to_s
    if file == "logo-classic.png"
      "branding/logo-classic.png"
    else
      "documents/#{document.id}/#{file}"
    end
  end

  def document_image_url(document, image)
    s3_url(document_image_key(document, image))
  end
end
