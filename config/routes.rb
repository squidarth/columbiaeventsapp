EventSalsa::Application.routes.draw do

  match '/calendar', to: 'events#calendar'
  resources :users do
    resources :events, only: [:index]
    resources :attendings, only: [] do
      get 'index', on: :collection, action: 'index_for_user'
    end
  end
  resources :attendings, only: [:create, :update] do
    get 'index', on: :collection, action: 'index_for_user'
  end
  resources :categories, only: [:index, :show] do
    resources :events, only: [:index] do
      collection do
        get 'upcoming'
        get 'recent'
      end
    end
  end
  resources :events do
    resources :comments, :only => [:create]
    resources :attendings, only: [:index, :create]
    collection do
      get 'upcoming'
      get 'recent'
      get 'pull'
    end
  end

  #resources :sessions, :only => [:new, :create, :destroy]
  match '/current_user' => 'sessions#show'
  match '/signout' => 'sessions#destroy'

  match '/users/:id/confirm/:confirmcode', :to => 'users#confirm'
  match '/users/:id/password', :to => 'users#changepassword'
  match '/auth/:provider/callback', :to => 'authorizations#create'
  root :to => 'pages#home'
end
