require "cgi"
require "openssl"

module ApplicationHelper
  def safe_asset_path(asset_name)
    asset_path(asset_name)
  rescue Sprockets::Rails::Helper::AssetNotFound, Sprockets::Rails::Helper::AssetNotPrecompiled
    nil
  end

  def s3_object_exists?(key)
    return false if key.blank?

    return true if !Rails.env.development? && !Rails.env.test?

    begin
      creds = Rails.application.config_for(:s3)
      Aws::S3::Client.new(
        region: creds["region"],
        access_key_id: creds["access_key_id"],
        secret_access_key: creds["secret_access_key"]
      ).head_object(bucket: creds["bucket"], key: key)
      true
    rescue Aws::S3::Errors::NotFound, Aws::S3::Errors::Forbidden, Aws::Errors::ServiceError
      false
    end
  end

  def image_proxy_url(key, width:, height: nil, fit: nil, format: nil)
    return if key.blank?

    base = ENV["IMAGE_PROXY_BASE_URL"]
    signing_key = ENV["IMAGE_PROXY_SIGNING_KEY"]
    bucket = ENV["AWS_BUCKET"]

    unless base.present? && signing_key.present? && bucket.present?
      return S3Service.new.presigned_url(key)
    end

    path_key = key.to_s.sub(%r{\A/}, "")
    path = "/#{path_key}"

    params = {
      width: width,
      height: height,
      fit: fit,
      format: format
    }.compact

    query = params
      .sort_by { |k, _| k.to_s }
      .map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }
      .join("&")

    signature_base = query.present? ? "#{path}?#{query}" : path
    signature = OpenSSL::HMAC.hexdigest("sha256", signing_key, signature_base)
    final_query = query.present? ? "#{query}&signature=#{signature}" : "signature=#{signature}"

    "#{base.chomp("/")}#{path}?#{final_query}"
  end

  def fallback_image_tag(src, fallback: nil, **options)
    return if src.blank?

    fallback_url = fallback.presence || image_path("branding/logo.png")
    data = (options[:data] || {}).dup
    data[:controller] = [data[:controller], "fallback-image"].compact.join(" ")
    data[:"fallback_image_src_value"] = fallback_url
    data[:action] = [data[:action], "error->fallback-image#swap"].compact.join(" ")
    options[:data] = data
    image_tag(src, **options)
  end
end
