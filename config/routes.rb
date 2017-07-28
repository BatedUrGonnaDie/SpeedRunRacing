Rails.application.routes.draw do
  root to: 'races#index'
  devise_for :users
end
