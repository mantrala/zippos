Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'zips#index'
  resources :zips, only: [:index]

  post 'search', to: 'zips#search', as: 'search'
end
