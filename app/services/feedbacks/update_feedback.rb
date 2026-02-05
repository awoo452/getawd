module Feedbacks
  class UpdateFeedback
    Result = Struct.new(:success?, :feedback, keyword_init: true)

    def self.call(feedback_id:, params:)
      new(feedback_id: feedback_id, params: params).call
    end

    def initialize(feedback_id:, params:)
      @feedback_id = feedback_id
      @params = params
    end

    def call
      feedback = Feedback.find(@feedback_id)
      if feedback.update(@params)
        Result.new(success?: true, feedback: feedback)
      else
        Result.new(success?: false, feedback: feedback)
      end
    end
  end
end
