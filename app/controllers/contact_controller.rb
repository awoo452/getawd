class ContactController < ApplicationController
  def index
    data = Contact::IndexData.call
    @contact_info = data.contact_info
  end

  def create
    return head :ok if params[:website].present?

    Contact::SendMessage.call(
      name: params[:name],
      email: params[:email],
      message: params[:message]
    )

    redirect_to contact_path
  end
end
