class ContactController < ApplicationController
  def index
    @contact_info = YAML.load_file(Rails.root.join('config', 'contact_info.yml'))
  end

  def create
    return head :ok if params[:website].present?

    ContactMailer
      .contact_email(params[:name], params[:email], params[:message])
      .deliver_later

    redirect_to contact_path
  end
end