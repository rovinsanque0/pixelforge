Rails.application.routes.draw do
  get "orders/new"
  get "orders/show"
  get "carts/show"
  get "products/index"
  get "products/show"
  devise_for :users

  namespace :admin do
    get "dashboard/index"
    root "dashboard#index"
    resources :products
    resources :categories
  end

  root "products#index" # 2.1 front page

  resources :products, only: %i[index show]

  resource :cart, only: [:show] do
    post :add_item
    patch :update_item
    delete :remove_item
  end

  resources :orders, only: %i[new create show]
end
