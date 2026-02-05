module Feedbacks
  class CreateFeedback
    Result = Struct.new(:success?, :feedback, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      feedback = Feedback.new(@params)
      if feedback.save
        Result.new(success?: true, feedback: feedback)
      else
        Result.new(success?: false, feedback: feedback)
      end
    end
  end
end
