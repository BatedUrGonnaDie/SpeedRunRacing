Rails.application.routes.draw do
  root to: 'races#index'
  mount ActionCable.server => "/cable"

  devise_for :users
  get '/users/:user', to: 'users#index', as: :user_public_profile

  get '/auth/failure',             to: 'twitch#failure'
  get '/auth/:provider/callback',  to: 'twitch#create'

  get '/games/autocomplete/:query', to: 'games#autocomplete'

  get '/races/completed/', to: 'races#completed', as: :completed_races
  resources :races, only: [:index, :show]

  resources :games, only: [:show, :index]

  post '/timesync', to: 'time#timesync', as: :timesync
end
