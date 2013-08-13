Flickr::Application.routes.draw do
  resources :users

  resources :videos

  resources :photos do
    member do
      post :buy
    end
    
    collection do #when write collection it will have specific routes that look  like this: /photos/search
      #if you use member route looks like this: photos/:id/search
      post :search, to: "photos#search"
    end

    resources :comments
  end

  resources :sessions, only: [:new,:create,:destroy]

  get 'logout', to: "sessions#destroy" #need an alias for destory which is by default a post action --> users can't get to this without a 'get' and therefore need the alias for destroy

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#new'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
