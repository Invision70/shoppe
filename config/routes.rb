Shoppe::Engine.routes.draw do

  get 'attachment/:id/:filename.:extension' => 'attachments#show'

  resources :customers do
    post :search, :on => :collection
    resources :addresses
  end
  get "/customers/login/:id", :to => "customers#login", :as => 'login_customer'
  post "/customers/confirm/:id", :to => "customers#confirm", :as => 'confirm_customer'

  resources :product_attachments, :only => [:destroy, :update, :show]
  post "/product_attachments/:id", :to => "product_attachments#update"

  resources :product_categories do
    resources :localisations, controller: "product_category_localisations"

    collection do
      get :manage
      post :rebuild
    end
  end

  resources :product_category_tree, controller: "product_category_tree", :only => [:new, :edit, :update]

  resources :products do
    resources :variants
    resources :localisations, controller: "product_localisations"
    collection do
      get :import
      post :import
    end
  end
  resources :orders do
    collection do
      post :search
    end
    member do
      post :accept
      post :reject
      post :ship
      get :despatch_note
    end
    resources :payments, :only => [:create, :destroy] do
      match :refund, :on => :member, :via => [:get, :post]
    end
  end
  resources :stock_level_adjustments, :only => [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :users
  resources :countries
  resources :states
  resources :attachments, :only => :destroy
  resources :product_attributes
  resources :newsletters do
    get :restore
  end
  resources :promo_codes
  resources :pages

  get 'settings'=> 'settings#edit'
  post 'settings' => 'settings#update'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'login/reset' => 'sessions#reset', :via => [:get, :post]

  delete 'logout' => 'sessions#destroy'
  root :to => 'dashboard#home'
end
