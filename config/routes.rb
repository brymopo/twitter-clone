Rails.application.routes.draw do
  devise_for :users

  resources :users, path: "", param: :slug, only: %i[show] do
    resources :tweets, only: %i[new create]
  end
end
