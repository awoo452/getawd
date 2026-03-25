module ChangeRequests
  class UpdateChangeRequest
    Result = Struct.new(:success?, :change_request, keyword_init: true)

    def self.call(change_request_id:, params:)
      new(change_request_id: change_request_id, params: params).call
    end

    def initialize(change_request_id:, params:)
      @change_request_id = change_request_id
      @params = params
    end

    def call
      change_request = ChangeRequest.find(@change_request_id)
      if change_request.update(@params)
        Result.new(success?: true, change_request: change_request)
      else
        Result.new(success?: false, change_request: change_request)
      end
    end
  end
end
