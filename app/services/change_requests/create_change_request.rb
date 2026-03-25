module ChangeRequests
  class CreateChangeRequest
    Result = Struct.new(:success?, :change_request, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      change_request = ChangeRequest.new(@params)
      if change_request.save
        Result.new(success?: true, change_request: change_request)
      else
        Result.new(success?: false, change_request: change_request)
      end
    end
  end
end
