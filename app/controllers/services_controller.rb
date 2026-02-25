class ServicesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    data = Services::IndexData.call(paginator: method(:paginate))
    @services = data.services
    @services_page = data.services_page
    @services_total_pages = data.services_total_pages
  end
end
