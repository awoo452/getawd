module DocumentsHelper
  def document_image_url(document, image)
    s3_url("documents/#{document.id}/#{image['file']}")
  end
end