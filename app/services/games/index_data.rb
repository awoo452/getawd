module Games
  class IndexData
    Result = Struct.new(:games, :games_page, :games_total_pages, keyword_init: true)

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      scope = Game.where(show_to_public: true).order(created_at: :desc)
      games, games_page, games_total_pages = @paginator.call(scope, per_page: 25)

      Result.new(
        games: games,
        games_page: games_page,
        games_total_pages: games_total_pages
      )
    end
  end
end
