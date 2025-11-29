module DocumentsHelper
  def document_image_url(document, filename)
    "https://getawd-prod.s3.amazonaws.com/documents/#{document.id}/#{filename}"
  end
end