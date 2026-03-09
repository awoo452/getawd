class ApplicationController < ActionController::Base
  before_action :ensure_canonical_host
  before_action :authenticate_user!

  private

  def ensure_canonical_host
    return unless Rails.env.production?

    canonical_host = "getawd.com"
    return if request.host.blank? || request.host == canonical_host
    return if request.path == "/up"

    redirect_to "#{request.protocol}#{canonical_host}#{request.fullpath}",
      allow_other_host: true,
      status: :moved_permanently
  end

  def paginate(scope, per_page: 25)
    page = (params[:page] || 1).to_i
    total_pages = (scope.count / per_page.to_f).ceil
    [scope.offset((page - 1) * per_page).limit(per_page), page, total_pages]
  end
end
