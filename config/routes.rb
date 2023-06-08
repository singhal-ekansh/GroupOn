Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, except: [:destroy]
  get "user-verify/:token", to: "users#verify_user", as: "user-verify"
  
  resources :request_passwords, only: [:create, :new]
  
  resources :reset_passwords, only: [:create, :new]

  resources :sessions, only: [:create, :new, :destroy]

  # resources :orders, only: [:new, :show, :create]
  resources :deals, only: [:index, :show] do 
    post 'like'
    get "search", on: :collection
    get "filter", on: :collection
    resources :orders, only: [:new, :create]
  end

  resources :orders, only: [:index]
  get 'order-success', to: 'orders#placed'
  get 'order-failed', to: 'orders#failed'

  namespace :admin do
    resources :deals
    resources :reports, only: [:index]
    post 'filter-deals', to: 'reports#filter_deal'
  end

  resources :coupons, only: [:index]
  root "admin/deals#index"
end
