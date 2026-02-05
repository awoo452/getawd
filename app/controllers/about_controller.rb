class AboutController < ApplicationController
  def index
    data = About::IndexData.call
    @about_sections = data.about_sections
  end
end
