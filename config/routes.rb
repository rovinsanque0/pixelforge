Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get "dashboard/index"
    root "dashboard#index"
    resources :products
    resources :categories
    resources :pages, only: [:edit, :update] 
  end

  get "/about", to: "pages#about", as: :about
  get "/contact", to: "pages#contact", as: :contact
  post "/contact_submit", to: "pages#contact_submit", as: :contact_submit

  root "products#index"

  resources :products, only: %i[index show]

  # ✅ ONLY ONE orders resource
  resources :orders, only: %i[new create show index]

  resource :cart, only: [:show] do
    post :add_item
    patch :update_item
    delete :remove_item
  end
end
