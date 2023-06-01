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
    post 'like'
    get "search", on: :collection
    get "filter", on: :collection
  end   

  namespace :admin do
    resources :deals do
      member do 
        patch 'publish'
        patch 'unpublish'
      end
    end
  end
  root "admin/deals#index"
end
