module Bugs
  class UpdateBug
    Result = Struct.new(:success?, :bug, keyword_init: true)

    def self.call(bug_id:, params:)
      new(bug_id: bug_id, params: params).call
    end

    def initialize(bug_id:, params:)
      @bug_id = bug_id
      @params = params
    end

    def call
      bug = Bug.find(@bug_id)
      if bug.update(@params)
        Result.new(success?: true, bug: bug)
      else
        Result.new(success?: false, bug: bug)
      end
    end
  end
end
