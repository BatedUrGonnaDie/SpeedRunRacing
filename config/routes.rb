Rails.application.routes.draw do
  root to: 'races#index'
  devise_for :users
  mount ActionCable.server => "/cable"

  get '/auth/failure', to: 'twitch#failure'
  get '/auth/:provider/callback', to: 'twitch#create'

  resources :races, except: [:new, :edit, :destroy]
end
