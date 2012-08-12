EventSalsa::Application.routes.draw do

  match '/calendar', to: 'events#calendar'
  resources :attendings
  resources :users

  #resources :sessions, :only => [:new, :create, :destroy]
  match '/current_user' => 'sessions#show'
  match '/signout' => 'sessions#destroy'

  match '/users/:id/confirm/:confirmcode', :to => 'users#confirm'
  match '/users/:id/password', :to => 'users#changepassword'
  match '/users/destroy', :to => 'users#destroy'
  match '/signup', :to => 'users#new'
  match '/verify', :to => 'users#wait'
  match '/allusers', :to => 'users#index'
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
    collection do
      get 'upcoming'
      get 'recent'
      get 'pull'
    end
  end
  match '/auth/:provider/callback', :to => 'authorizations#create'
  namespace :admin do
    get '/', action: 'main'
    get '/delete', action: 'destroy'
    get '/addevent', action: 'add'
    get '/changeevent', action: 'change'
    get 'update'
    get 'create'
  end
  match '/attendings/attend', :to => 'attendings#attend'
  match '/attendings/maybe', :to => 'attendings#maybe'
  match "comments/create" => "comments#create"
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'

  root :to => 'pages#home'
end
