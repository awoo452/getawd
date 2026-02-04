# app/services/rewards/index_data.rb
module Rewards
  class IndexData
    Result = Struct.new(
      :redeemed_levels,
      :earned_by_level,
      :task_rewards_today,
      :public_games,
      :recent_rewards,
      :rewards,
      :rewards_page,
      :rewards_total_pages,
      keyword_init: true
    )

    def self.call(paginator:)
      new(paginator: paginator).call
    end

    def initialize(paginator:)
      @paginator = paginator
    end

    def call
      today = Time.zone.today.to_s

      redeemed = Reward.where(
        kind: "redeemed",
        scope: "level"
      ).where("reward_payload ->> 'earned_date' = ?", today)

      redeemed_levels = redeemed
        .pluck(Arel.sql("(reward_payload->>'level')::int"))
        .to_set

      earned_levels = Reward.where(
        kind: "earned",
        scope: "level"
      ).where("reward_payload ->> 'earned_date' = ?", today)

      earned_by_level = earned_levels.index_by { |r| r.reward_payload["level"].to_i }

      completed = Reward.where(kind: "completed")
                        .where("updated_at >= ?", 7.days.ago)

      task_rewards_today = Reward.where(
        scope: "task",
        kind: "earned"
      ).where("reward_payload ->> 'earned_date' = ?", today)

      public_games = Game.where(show_to_public: true)

      recent_rewards = (redeemed + completed).uniq
      rewards, rewards_page, rewards_total_pages =
        @paginator.call(Reward.order(created_at: :desc), per_page: 50)

      Result.new(
        redeemed_levels: redeemed_levels,
        earned_by_level: earned_by_level,
        task_rewards_today: task_rewards_today,
        public_games: public_games,
        recent_rewards: recent_rewards,
        rewards: rewards,
        rewards_page: rewards_page,
        rewards_total_pages: rewards_total_pages
      )
    end
  end
end
