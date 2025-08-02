require "aws-sdk-s3"

class S3Service
  def initialize
    creds = Rails.application.config_for(:s3)
    @s3 = Aws::S3::Resource.new(
      region: creds["region"],
      access_key_id: creds["access_key_id"],
      secret_access_key: creds["secret_access_key"]
    )
    @bucket = @s3.bucket(creds["bucket"])
  end

  def upload(file_path, key, public: false)
    opts = {}
    obj = @bucket.object(key)
    obj.upload_file(file_path, opts)
    public ? obj.public_url : obj.key
  end

  def presigned_url(key, expires_in: 3600)
    creds = Rails.application.config_for(:s3)
    signer = Aws::S3::Presigner.new(
      region: creds["region"],
      access_key_id: creds["access_key_id"],
      secret_access_key: creds["secret_access_key"]
    )
    signer.presigned_url(:get_object, bucket: creds["bucket"], key: key, expires_in: expires_in)
  end
end
