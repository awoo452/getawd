Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, defaults: { format: :html }, controllers: {
    sessions: "users/sessions"
  }

  # Static pages
  get 'about',     to: 'about#index'
  get 'contact',   to: 'contact#index'
  post "contact", to: "contact#create"
  get "/terms", to: "legal#terms"
  get "/privacy", to: "legal#privacy"
  get "/accessibility", to: "legal#accessibility"
  get 'dashboard', to: 'dashboard#index'
  get 'calendar',        to: 'calendar#daily'
  get 'calendar/daily',  to: 'calendar#daily'
  get 'calendar/daily/:start_date', to: 'calendar#daily', as: :calendar_daily_date
  get 'calendar/monthly', to: 'calendar#monthly'
  get 'calendar/monthly/:start_date', to: 'calendar#monthly', as: :calendar_monthly_date
  get 'landscaping', to: 'landscaping#index'
  get 'media/*key', to: 's3_proxy#show', as: :s3_media, format: false

  # Resources
  resources :goals do
    resources :recurring_tasks, only: [:create, :update, :destroy]
  end
  resources :tasks do
    member do
      patch :complete_on_time
    end
  end
  resources :documents
  get '/docs', to: 'documents#public_index', as: :public_docs
  get '/docs/:slug', to: 'documents#show_by_slug', as: :doc
  # remove plural resources; using singular controllers above
  resources :blog_posts, only: [:index, :show]
  resources :change_requests, only: [:new, :create, :index], path: "changes"
  get "/feedback", to: redirect("/changes")
  get "/feedback/new", to: redirect("/changes/new")
  resources :bugs, only: [:new, :create, :index]
  resources :games,     only: [:index, :show]
  resources :ideas, only: [:show]
  resources :projects,  only: [:index, :show]
  resources :services,  only: [:index]
  resources :videos,    only: [:index, :show]
  resources :reports, only: [:index]
  resources :rewards, only: [:index, :show, :update] do
    collection do
      post :redeem, to: "reward_redemptions#redeem"
    end

    member do
      post :redeem_any, to: "reward_redemptions#redeem_any"
    end
  end

  post "rewards/:id/redeem_task", to: "reward_redemptions#redeem_task", as: :redeem_task_reward

  ## If you're still reading you deserve to know about this
  get  "/blackjack",        to: "blackjack#show",  as: :blackjack

  post "/blackjack/bet",   to: "blackjack#bet",       as: :bet_blackjack
  post "/blackjack/clear", to: "blackjack#clear_bet", as: :clear_bet_blackjack
  post "/blackjack/deal",  to: "blackjack#deal",      as: :deal_blackjack
  post "/blackjack/hit",   to: "blackjack#hit",       as: :hit_blackjack
  post "/blackjack/stand", to: "blackjack#stand",     as: :stand_blackjack
  post "/blackjack/reset", to: "blackjack#reset",     as: :reset_blackjack
  post "/blackjack/hard",  to: "blackjack#hard_reset",as: :hard_reset_blackjack

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
