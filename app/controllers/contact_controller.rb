class ContactController < ApplicationController
  def index
    @contact_info = YAML.load_file(Rails.root.join('config', 'contact_info.yml'))
  end

  def create
    ContactMailer
      .contact_email(params[:name], params[:email], params[:message])
      .deliver_now

    redirect_to contact_path
  end
end