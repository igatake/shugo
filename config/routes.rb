Rails.application.routes.draw do
  root to: 'maps#index'
  resources :maps, only: [:index]
  get 'about', to: 'about#index'
  post 'fetch_shops', to: 'maps#fetch_shops'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
