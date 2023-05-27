Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  get "/user-verify", to: "users#verify_user"
  
  resources :request_passwords, only: [:create, :new]
  
  resources :reset_passwords, only: [:create, :new]

  resources :sessions, only: [:create, :new, :destroy]

  resources :deals, only: [:index, :show] do 
    post 'like'
  end   

  namespace :admin do
    resources :deals
  end

  root "users#new"
end
