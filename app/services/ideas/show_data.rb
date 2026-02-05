module Ideas
  class ShowData
    Result = Struct.new(:idea, :emoji, keyword_init: true)

    def self.call(idea_id:)
      new(idea_id: idea_id).call
    end

    def initialize(idea_id:)
      @idea_id = idea_id
    end

    def call
      idea = Idea.includes(goals: :tasks).find(@idea_id)
      emoji = IDEAS[idea.title] || "❓"

      Result.new(idea: idea, emoji: emoji)
    end
  end
end
