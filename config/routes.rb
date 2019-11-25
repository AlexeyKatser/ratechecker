Rails.application.routes.draw do

	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'

  resources :currencies
    root "currencies#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/admin', to: 'currencies#new', as: :admin
  match '/admin', to: 'currencies#new', via: [:get, :post]
 # resources :currencies, path: "admin", as: :currencies, only: [:create, :new]
end
