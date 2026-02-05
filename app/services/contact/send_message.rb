module Contact
  class SendMessage
    def self.call(name:, email:, message:)
      new(name: name, email: email, message: message).call
    end

    def initialize(name:, email:, message:)
      @name = name
      @email = email
      @message = message
    end

    def call
      ContactMailer.contact_email(@name, @email, @message).deliver_later
    end
  end
end
