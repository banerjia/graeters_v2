Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  scope '/graeters' do
    namespace :manage, constraints: {format: :html} do
      resources :retailers

      root 'manage/retailers#index'
    end
    
    get 'retailers', to: "retailers#index", constraints: {format: :html}

    scope path: ":retailer", as: "retailer", constraints: {format: :html} do
      # Default to Retailer Show if no action is specified for /<something>
      get "/", to: "retailers#show"

      # Stores by State, the sequence matters here so that stores/:id does not get picked
      # up before this path
      get 'stores/:state_code', to: 'stores#index', constraints: {state_code: /[A-Z]+/}, as: "stores_by_state"

      # The rest of the paths for retailer/stores
      resources :stores , only: [:index, :show]

      # Paths for retailer/comments
      resources :comments, only: [:index, :show, :destroy]


      root "retailers#show", as: :retailer_root
    end

    root "retailers#index", constraints: {format: :html}
  end
end
