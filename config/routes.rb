Rails.application.routes.draw do

  get 'order_items/create'

  get 'order_items/update'

  get 'order_items/destroy'

  get 'carts/show'

  root 'welcome#index'
  get 'welcome/index'
  get 'admin/index'


  devise_for :users
  resources :users
  resources :products
  resources :product_prices
  resources :categories
  resources :groups

  resources :orders do
    patch :update_payment, on: :member
  end



  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]

  #Custom Order Methods
  get '/orders/view/:id', to: 'orders#view', as: 'view_order'
  get '/orders/payment/:id', to: 'orders#payment', as: 'payment_order'

  #Contact Us
  #get 'welcome/contacts', to: 'welcome#contact', as: 'contact_us'

  match '/contacts', to: 'contacts#new', via: 'get'
  resources "contacts", only: [:new, :create]


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
