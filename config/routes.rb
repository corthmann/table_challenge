Rails.application.routes.draw do

  root 'application#index'

  namespace :api do
    resources :movies, only: [:index]
  end

end
