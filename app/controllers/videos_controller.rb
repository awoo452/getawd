class VideosController < ApplicationController
  def index
    @videos, @videos_page, @videos_total_pages =
      paginate(Video.order(created_at: :desc), per_page: 25)
  end

  def show
    @video = Video.find(params[:id])
  end
end
