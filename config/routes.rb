Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope '/graeters' do
    namespace :manage do
      resources :retailers

      root 'manage/retailers#index'
    end

    scope path: ":retailer" do
      get "/", to: "retailers#index"
      resources :stores , only: [:index]

      root "retailers#index", as: :retailer_root
    end
  end

end
