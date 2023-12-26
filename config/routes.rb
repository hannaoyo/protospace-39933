Rails.application.routes.draw do
  devise_for :users
  get 'articles/index' # Defines the root path route ("/")
  root to: 'prototypes#index' # root "articles#index"
  resources :prototypes do
    resources :comments, only: :create
  end
  resources :users, only: [:show, :edit, :update]
end
