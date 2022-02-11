Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope '/graeters' do
    namespace :manage do
      resources :retailers

      root 'manage/retailers#index'
    end
    
    get 'retailers', to: "retailers#index"

    scope path: ":retailer", as: "retailer" do
      get "/", to: "retailers#show"
      #resources :stores , only: [:index, :show]
      resources :comments, only: [:index, :show, :destroy]

      root "retailers#show", as: :retailer_root
    end

    root "retailers#index"
  end

end
