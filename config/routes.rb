Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:show, :create, :update, :destroy] do
      
      collection do
        get '/current-user', to: 'users#loggedInUser'
        # ! this really doesn't have to be in here but I guess it's fine
      end

      member do
        get 'managed-properties', to: 'properties#index'
        get 'manager', to: 'users#manager'
        get 'guest', to: 'users#guest'
        get 'bookings', to: 'bookings#index'
        get 'managed-bookings', to: 'bookings#managedIndex'
      end
    end

    resources :ratings do
      collection do
        post 'add-manager-rating', to: 'ratings#addManagerRating'
        post 'add-guest-rating', to: 'ratings#addGuestRating'
  
        put 'update-manager-rating', to: 'ratings#updateManagerRating'
        put 'update-guest-rating', to: 'ratings#updateGuestRating'
      end
    end

    resources :properties, only: [:index, :show, :create, :update, :destroy] do
      member do
        get 'bookings', to: 'bookings#index'
      end
    end
    resources :bookings, only: [:show, :create, :update, :destroy]

    resource :session, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
end
