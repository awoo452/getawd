module Feedbacks
  class IndexData
    Result = Struct.new(:open_feedback, :completed_feedback, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(
        open_feedback: Feedback.open.order(created_at: :desc),
        completed_feedback: Feedback.completed.order(updated_at: :desc)
      )
    end
  end
end
