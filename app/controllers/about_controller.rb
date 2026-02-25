class AboutController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data = About::IndexData.call
    @about_sections = data.about_sections
  end
end
