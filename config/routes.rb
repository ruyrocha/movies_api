Rails.application.routes.draw do
  defaults format: :json do
    resource :auth, only: %i(create), controller: :authentication
    resources :movies
    resources :people
  end
end
