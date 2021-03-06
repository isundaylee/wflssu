Su::Application.routes.draw do

  # match "sms/dispatchA", to: 'sms#dispatchA', via: [:post]
  post "sms/send", to: 'sms#send_message'
  get "sms/index"
  post "sms/transfer"

  get "notifications/visit"

  resources :notifications, only: [] do
    member do
      get 'visit'
    end
  end

  resources :attendences, only: [:destroy] do
    member do
      get 'accept'
      get 'reject'
    end 
  end

  resources :events, only: [:index, :new, :create, :edit, :update, :destroy] do
    member do
      get 'attend'
      get 'all_attend'
    end
  end

  resource :session, only: [:new, :create, :destroy] do 
  end

  resources :shortlogs, only: [:destroy] do
  end

  resources :members, only: [:new, :create, :edit, :update, :index, :destroy, :show] do 
    member do
      get 'qrcode(/:size)', action: 'qrcode', as: 'qrcode'
    end

    collection do
      get 'search'
      get 'by_code_number/:code_number', action: 'member_by_code_number', as: 'by_code_number'
    end
  end

  resources :departments, only: [:new, :create, :edit, :update, :index] do
    resources :members, only: [:index, :new]
  end

  get "pages/homepage"

  root :to => "pages#homepage"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
