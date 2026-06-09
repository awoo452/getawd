module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_api_token!

      private

      def authenticate_api_token!
        expected = ENV["GETAWD_API_TOKEN"].presence
        return head :unauthorized unless expected

        provided = request.headers["Authorization"]&.delete_prefix("Bearer ")&.strip
        head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(expected, provided.to_s)
      end
    end
  end
end
