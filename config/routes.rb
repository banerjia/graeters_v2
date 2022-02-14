Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  scope '/graeters' do
    namespace :manage, constraints: {format: :html} do
      resources :retailers

      root 'manage/retailers#index'
    end
    
    get 'retailers', to: "retailers#index", constraints: {format: :html}

    scope path: ":retailer", as: "retailer", constraints: {format: :html} do
      get "/", to: "retailers#show"
      resources :stores , only: [:index, :show]
      resources :comments, only: [:index, :show, :destroy]

      root "retailers#show", as: :retailer_root
    end

    root "retailers#index", constraints: {format: :html}
  end
end
