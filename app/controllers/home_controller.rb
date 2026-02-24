class HomeController < ApplicationController
  def index
    data = Home::IndexData.call
    @featured_projects = data.featured_projects
    @featured_blog_posts = data.featured_blog_posts
    @featured_videos = data.featured_videos
    @featured_services = data.featured_services
  end
end
