Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :new, :show]
  get "/user-verify", to: "users#verify_user"
  
  resources :request_passwords, only: [:create, :new]
  # get "/reset-password-email", to: "users#forget_password_get"
  # post "/reset-password-email", to: "users#forget_password_post"

  resources :reset_passwords, only: [:create, :new]
  # get "/reset-password", to: "users#reset_password_get"
  # post "/reset-password", to: "users#reset_password_post"

  resources :sessions, only: [:create, :new, :destroy]
  root "users#new"
end
