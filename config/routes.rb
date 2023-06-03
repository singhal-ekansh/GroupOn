Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  get "user-verify/:token", to: "users#verify_user", as: "user-verify"
  
  resources :request_passwords, only: [:create, :new]
  
  resources :reset_passwords, only: [:create, :new]

  resources :sessions, only: [:create, :new, :destroy]

  # resources :orders, only: [:new, :show, :create]
  resources :deals, only: [:index, :show] do 
    post 'like'
    resources :orders, only: [:new, :create]
  end

  get 'order-success', to: 'orders#placed'
  get 'order-failed', to: 'orders#failed'

  namespace :admin do
    resources :deals
  end
  root "admin/deals#index"
end
