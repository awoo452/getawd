class S3ProxyController < ApplicationController
  def show
    key = params[:key].to_s
    if params[:format].present?
      key = "#{key}.#{params[:format]}"
    end
    return head :not_found if key.blank?

    url = S3Service.new.presigned_url(key)
    return head :not_found if url.blank?

    redirect_to url, allow_other_host: true
  end
end
