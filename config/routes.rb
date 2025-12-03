Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get "dashboard/index"
    root "dashboard#index"

    resources :products
    resources :categories
    resources :pages, only: [:edit, :update]

    resources :orders, only: [:index] do
      member do
        patch :toggle_shipping
      end
    end
  end

  get "/about", to: "pages#about", as: :about
  get "/contact", to: "pages#contact", as: :contact
  post "/contact_submit", to: "pages#contact_submit", as: :contact_submit

  post "/create_checkout_session", to: "payments#create_checkout_session", as: :create_checkout_session
  get "/order_success", to: "payments#order_success", as: :order_success
  get "/order_cancel", to: "payments#order_cancel", as: :order_cancel

  root "products#index"

  resources :products, only: %i[index show]
  resources :orders, only: %i[new create show index]

  resource :cart, only: [:show] do
    post :add_item
    patch :update_item
    delete :remove_item
  end
end



