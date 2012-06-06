Sidsapp::Application.routes.draw do
  
  match '/calendar', :to => 'events#calendar'
  resources :attendings
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users
  resources :categories, only: [] do
    resources :events, only: [:index]
  end
  resources :events do
    resources :comments, :only => [:create]
  end
  
  match '/auth/:provider/callback', :to => 'authorizations#create'
  match '/api/topevents', :to => 'api#events'	
  match '/api/query', :to => 'api#query'	
  match '/api/emails', :to => 'api#emails'
  match '/events/pull', :to => 'events#pull'
  
  match '/admin', :to => 'admin#main'
  match '/admin/delete', :to => 'admin#destroy'
  match '/admin/addevent', :to => 'admin#add'
  match '/admin/changeevent', :to => 'admin#change'
  match '/admin/update', :to => 'admin#update'
  match '/admin/create', :to => 'admin#create'
  match '/users/:id/confirm/:confirmcode', :to => 'users#confirm'
  match '/verify', :to => 'users#wait'
  match '/attendings/attend', :to => 'attendings#attend'
  match '/attendings/maybe', :to => 'attendings#maybe'
  match '/users/:id/password', :to => 'users#changepassword'
  match '/users/destroy', :to => 'users#destroy'
  match "comments/create" => "comments#create"
  match '/allusers', :to => 'users#index'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  root :to => 'pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
