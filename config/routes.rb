Rails.application.routes.draw do
  
  # DEV Note: SCOPE has been added for development environment
  scope '/graeters' do 
    resources :retailers

    root 'retailers#index'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
