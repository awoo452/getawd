module Bugs
  class IndexData
    Result = Struct.new(:open_bugs, :completed_bugs, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(
        open_bugs: Bug.open.order(created_at: :desc),
        completed_bugs: Bug.completed.order(updated_at: :desc)
      )
    end
  end
end
