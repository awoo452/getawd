class AboutController < ApplicationController
  def index
    @about_sections = AboutSection.all
  end
end
