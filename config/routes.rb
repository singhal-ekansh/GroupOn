Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :new, :show]
  get "/user-verify", to: "users#verify_user"
  
  resources :request_passwords, only: [:create, :new]
  
  resources :reset_passwords, only: [:create, :new]
  
  resources :sessions, only: [:create, :new]
  root "users#new"
end
