class VideosController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data = Videos::IndexData.call(paginator: method(:paginate))
    @videos = data.videos
    @videos_page = data.videos_page
    @videos_total_pages = data.videos_total_pages
  end

  def show
    @video = Video.find(params[:id])
  end
end
