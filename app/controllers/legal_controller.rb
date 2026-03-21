class LegalController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_legal_content

  def terms
    @page = @legal_content.fetch("terms")
    @page_title = @page["title"]
  end

  def privacy
    @page = @legal_content.fetch("privacy")
    @page_title = @page["title"]
  end

  def accessibility
    @page = @legal_content.fetch("accessibility")
    @page_title = @page["title"]
  end

  private

  def load_legal_content
    path = Rails.root.join("config", "legal_content.json")
    @legal_content = JSON.parse(File.read(path))
    @effective_date = @legal_content["effective_date"]
  end
end
