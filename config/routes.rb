Rails.application.routes.draw do
  root to: 'races#index'
  mount ActionCable.server => '/cable'

  get '/health', to: 'static#health'

  get '/faq', to: 'static#faq', as: :faq

  devise_for :users
  get '/users/:username', to: 'users#index', as: :user_public_profile

  get '/auth/failure',             to: 'twitch#failure'
  get '/auth/:provider/callback',  to: 'twitch#create'

  get '/games/autocomplete/:query', to: 'games#autocomplete'

  get '/races/completed/', to: 'races#completed', as: :completed_races
  resources :races, only: [:index, :show]

  resources :games, only: [:show, :index], constraints: {id: /.*/}

  get '/search(?q=:q)', to: 'search#search', as: :search

  namespace :api do
    namespace :v1 do
      post '/timesync', to: 'time#create', as: :timesync
    end
  end
end
