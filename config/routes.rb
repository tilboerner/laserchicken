Laserchicken::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'entries#index'

  resources :sessions, only: [:create]
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy', via: :delete

  concern :serial do
    get 'next', on: :member
    get 'previous', on: :member
  end

  concern :see_all do
    put 'see_all', on: :collection
  end

  concern :entry_container do
    resources :entries, only: [:index, :show], concerns: [:serial, :see_all]
  end
  resources :entries, only: [:index, :show], concerns: [:serial, :see_all]


  resources :subscriptions, only: [:index, :show, :create, :destroy], concerns: [:serial, :entry_container]

  resources :user_states, only: [:show, :update], path: :states

  resources :users, only: [:index, :new, :create, :update, :destroy]

  resources :feeds, concerns: :entry_container do
    get :refresh_all, on: :collection
    get :refresh, on: :member
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
