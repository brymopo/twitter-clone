Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root to: "static_pages#index"

  resources :users, path: "", param: :username, only: [:show] do
    member do
      get :followers
      get :following
    end
    resources :tweets, only: %i[new create]
    resources :follows, only: %i[new create]
  end
end
