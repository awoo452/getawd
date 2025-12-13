class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(
      from: "contact@getawd.com",
      to: "aaronwood8888@gmail.com",
      reply_to: email,
      subject: "New GETAWD Contact Form Message"
    )
  end
end

