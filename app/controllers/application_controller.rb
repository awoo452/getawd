class ApplicationController < ActionController::Base
  
    private
  
    def paginate(scope, per_page: 25)
        page = (params[:page] || 1).to_i
        total_pages = (scope.count / per_page.to_f).ceil
        [scope.offset((page - 1) * per_page).limit(per_page), page, total_pages]
    end

end