Sidsapp::Application.routes.draw do
  
    match '/calendar', :to => 'events#calendar'
  resources :attendings
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users
  resources :events do
    resources :comments, :only => [:create]
  end
  
  match '/attendings/attend', :to => 'attendings#attend'
  match '/attendings/maybe', :to => 'attendings#maybe'
  match '/users/:id/password', :to => 'users#changepassword'
  match '/users/destroy', :to => 'users#destroy'
  match '/auth/:provider/callback', :to => 'authorizations#create'
  match "comments/create" => "comments#create"
  match '/allusers', :to => 'users#index'
  match '/signup', :to => 'users#new'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/glife', :to => 'categories#fraternities'
  match '/theater', :to => 'categories#theater'
  match '/sports', :to => 'categories#sports'
  match '/politics', :to => 'categories#politics'
  match '/careernetworking', :to => 'categories#careernetworking'
  match '/arts', :to => 'categories#arts'
  match '/culture', :to => 'categories#cultural'
  match '/communityservice', :to => 'categories#communityservice'
  match '/stuco', :to => 'categories#studentcouncil'
  match '/all', :to => 'categories#all'
  match '/other', :to => 'categories#other'
  
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
