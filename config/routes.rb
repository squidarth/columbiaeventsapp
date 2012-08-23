EventSalsa::Application.routes.draw do
  resources :users do
    resources :events, only: [:index]
    resources :memberships, only: [] do
      get 'index', on: :collection, action: 'index_for_user'
    end
    resources :attendings, only: [] do
      get 'index', on: :collection, action: 'index_for_user'
    end
  end

  resources :memberships, only: [] do
    get 'index', on: :collection, action: 'index_for_user'
  end
  resources :groups do
    resources :memberships, only: [] do
      get 'index', on: :collection, action: 'index_for_group'
    end
  end

  resources :attendings, only: [:create, :update] do
    get 'index', on: :collection, action: 'index_for_user'
  end
  resources :events do
    resources :attendings, only: [:create] do
      get 'index', on: :collection, action: 'index_for_event'
    end
    post 'fetch_from_facebook', on: :collection
  end
  resources :categories, only: [:index, :show] do
    resources :events, only: [:index] do
      collection do
        get 'upcoming'
        get 'recent'
      end
    end
  end

  #resources :sessions, only: [:new, :create, :destroy]
  match '/current_user' => 'sessions#show'
  match '/signout' => 'sessions#destroy'

  match '/auth/:provider/callback', to: 'authorizations#create'
  root to: 'pages#home'
end
