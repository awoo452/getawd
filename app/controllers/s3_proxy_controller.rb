class S3ProxyController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    data = S3Proxy::ShowData.call(key: params[:key], format: params[:format])
    return head :not_found if data.redirect_url.blank?
    return head :forbidden unless allowed_redirect?(data.redirect_url)

    redirect_to data.redirect_url, allow_other_host: true
  end

  private

  def allowed_redirect?(url)
    uri = URI.parse(url)
    return false unless uri.is_a?(URI::HTTP) && uri.host.present?

    allowed = s3_allowed_hosts
    return true if allowed.include?(uri.host)

    bucket = s3_bucket
    return false if bucket.blank?

    path_style_hosts = [
      "s3.#{s3_region}.amazonaws.com",
      "s3.amazonaws.com"
    ].compact

    path_style_hosts.include?(uri.host) && uri.path.start_with?("/#{bucket}/")
  rescue URI::InvalidURIError
    false
  end

  def s3_allowed_hosts
    bucket = s3_bucket
    region = s3_region

    hosts = []
    if bucket.present? && region.present?
      hosts << "#{bucket}.s3.#{region}.amazonaws.com"
      hosts << "#{bucket}.s3.amazonaws.com"
    end

    extra = ENV.fetch("S3_PROXY_ALLOWED_HOSTS", "")
    hosts + extra.split(",").map(&:strip).reject(&:empty?)
  end

  def s3_bucket
    @s3_bucket ||= Rails.application.config_for(:s3)["bucket"]
  end

  def s3_region
    @s3_region ||= Rails.application.config_for(:s3)["region"]
  end
end
