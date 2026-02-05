class S3ProxyController < ApplicationController
  def show
    data = S3Proxy::ShowData.call(key: params[:key], format: params[:format])
    return head :not_found if data.redirect_url.blank?

    redirect_to data.redirect_url, allow_other_host: true
  end
end
