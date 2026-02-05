module Landscaping
  class IndexData
    Result = Struct.new(:jobs, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(jobs: LandscapingJob.all)
    end
  end
end
