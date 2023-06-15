Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, except: [:destroy]
  get "user-verify/:token", to: "users#verify_user", as: "user-verify"
  
  resources :request_passwords, only: [:create, :new]
  
  resources :reset_passwords, only: [:create, :new]

  resources :sessions, only: [:create, :new, :destroy]
  
  resources :deals, only: [:index, :show] do 
    resource 'likes', only: [:create, :update, :destroy]
    get 'search', on: :collection
    get 'expired-deals', on: :collection
    resources :orders, only: [:new, :create]
  end   
  
  resources :orders, only: [:index] 
  get 'order-success', to: 'orders#placed'
  get 'order-failed', to: 'orders#failed'

  namespace :admin do
    resources :deals do
      member do 
        patch 'publish'
        patch 'unpublish'
      end
    end
  end

  resources :coupons, only: [:index]
  root "admin/deals#index"
end
