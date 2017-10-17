Rails.application.routes.draw do
  root to: 'races#index'
  devise_for :users

  get '/auth/failure', to: 'twitch#failure'
  get '/auth/:provider/callback', to: 'twitch#create'
end

