Rails.application.routes.draw do
  root to: 'maps#index'
  resources :maps, only: [:index]
  post 'fetch_test', to: 'maps#fetch_test'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
