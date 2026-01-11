Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  # Static pages
  get 'about',     to: 'about#index'
  get 'contact',   to: 'contact#index'
  post "contact", to: "contact#create"
  get 'dashboard', to: 'dashboard#index'
  get 'calendar',  to: 'calendar#show'
  get 'landscaping', to: 'landscaping#index'

  # Resources
  resources :goals
  resources :tasks do
    member do
      patch :complete_on_time
    end
  end
  resources :documents
  get '/docs/:slug', to: 'documents#show_by_slug', as: :doc
  resources :about,     only: [:index]
  resources :contacts,  only: [:index]
  resources :blog_posts, only: [:index, :show]
  resources :games,     only: [:index, :show]
  resources :ideas, only: [:show]
  resources :idea_stats, only: [:index]
  resources :projects,  only: [:index, :show]
  resources :videos,    only: [:index, :show]
  resources :rewards, only: [:index, :show, :update, :new, :create, :destroy] do
    collection do
      post :redeem
    end
  end
  post "rewards/:id/redeem_task", to: "rewards#redeem_task", as: :redeem_task_reward

end