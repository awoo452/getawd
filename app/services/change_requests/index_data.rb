module ChangeRequests
  class IndexData
    Result = Struct.new(:open_change_requests, :completed_change_requests, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(
        open_change_requests: ChangeRequest.open.order(created_at: :desc),
        completed_change_requests: ChangeRequest.completed.order(updated_at: :desc)
      )
    end
  end
end
