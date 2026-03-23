require "aws-sdk-s3"

class S3Service
  DEFAULT_EXPIRES_IN = 3600

  def initialize
    @config = s3_creds
    @configured = required_config_present?
    return unless @configured

    @s3 = Aws::S3::Resource.new(s3_options(@config))
    @bucket = @s3.bucket(@config[:bucket])
  end

  def configured?
    @configured
  end

  def upload(file_path, key, public: false)
    return nil unless ensure_configured!("upload")

    opts = {}
    obj = @bucket.object(key)
    obj.upload_file(file_path, opts)
    public ? obj.public_url : obj.key
  end

  def presigned_url(key, expires_in: DEFAULT_EXPIRES_IN)
    return nil unless ensure_configured!("presign")
    return nil if key.blank?

    signer = Aws::S3::Presigner.new(s3_options(@config))
    cache_key = "s3:presign:#{key}:#{expires_in}"
    cache_ttl = [expires_in.to_i - 60, 60].max
    Rails.cache.fetch(cache_key, expires_in: cache_ttl) do
      signer.presigned_url(:get_object, bucket: @config[:bucket], key: key, expires_in: expires_in)
    end
  end

  private

  def s3_creds
    config = Rails.application.config_for(:s3) || {}

    {
      bucket: config["bucket"].presence || ENV["AWS_BUCKET"],
      region: config["region"].presence || ENV["AWS_REGION"].presence || ENV["AWS_DEFAULT_REGION"].presence || "us-west-1",
      access_key_id: config["access_key_id"].presence || ENV["AWS_ACCESS_KEY_ID"].presence,
      secret_access_key: config["secret_access_key"].presence || ENV["AWS_SECRET_ACCESS_KEY"].presence
    }
  end

  def required_config_present?
    [@config[:bucket], @config[:region], @config[:access_key_id], @config[:secret_access_key]].all?(&:present?)
  end

  def ensure_configured!(action)
    return true if configured?
    return false unless Rails.env.production?

    raise "S3Service not configured for #{action}. Set AWS_REGION (or AWS_DEFAULT_REGION), AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_BUCKET."
  end

  def s3_options(creds)
    {
      region: creds[:region],
      access_key_id: creds[:access_key_id],
      secret_access_key: creds[:secret_access_key]
    }.compact
  end
end
