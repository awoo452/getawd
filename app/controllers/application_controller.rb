class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :public_controller?

  PUBLIC_CONTROLLERS = %w[
    about
    blackjack
    blog_posts
    contact
    home
    landscaping
    projects
    s3_proxy
    videos
  ].freeze

  private

  def paginate(scope, per_page: 25)
    page = (params[:page] || 1).to_i
    total_pages = (scope.count / per_page.to_f).ceil
    [scope.offset((page - 1) * per_page).limit(per_page), page, total_pages]
  end

  def public_controller?
    devise_controller? || PUBLIC_CONTROLLERS.include?(controller_name)
  end

end
