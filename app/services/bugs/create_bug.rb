module Bugs
  class CreateBug
    Result = Struct.new(:success?, :bug, keyword_init: true)

    def self.call(params:)
      new(params: params).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      bug = Bug.new(@params)
      if bug.save
        Result.new(success?: true, bug: bug)
      else
        Result.new(success?: false, bug: bug)
      end
    end
  end
end
