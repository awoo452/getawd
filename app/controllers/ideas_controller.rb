class IdeasController < ApplicationController
  before_action :authenticate_user!

  def show
    data = Ideas::ShowData.call(idea_id: params[:id])
    @idea = data.idea
    @emoji = data.emoji
  end
end
