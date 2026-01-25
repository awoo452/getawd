class ContactController < ApplicationController
  def index
    path = Rails.root.join("config", "contact_info.yml")
    @contact_info =
      if File.exist?(path)
        YAML.safe_load(File.read(path)) || {}
      else
        {}
      end
  end

  def create
    return head :ok if params[:website].present?

    ContactMailer
      .contact_email(params[:name], params[:email], params[:message])
      .deliver_later

    redirect_to contact_path
  end
end
