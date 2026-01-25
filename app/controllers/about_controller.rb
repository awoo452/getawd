class AboutController < ApplicationController
  def index
    path = Rails.root.join("config", "about_info.yml")
    @about_info =
      if File.exist?(path)
        YAML.safe_load(File.read(path)) || {}
      else
        {}
      end
  end
end
