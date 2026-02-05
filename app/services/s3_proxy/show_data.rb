module S3Proxy
  class ShowData
    Result = Struct.new(:redirect_url, keyword_init: true)

    def self.call(key:, format: nil)
      new(key: key, format: format).call
    end

    def initialize(key:, format:)
      @key = key.to_s
      @format = format
    end

    def call
      key = @key
      key = "#{key}.#{@format}" if @format.present?
      return Result.new(redirect_url: nil) if key.blank?

      url = S3Service.new.presigned_url(key)
      Result.new(redirect_url: url)
    end
  end
end
