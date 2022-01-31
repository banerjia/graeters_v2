Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope '/graeters' do
    namespace :manage do
      resources :retailers
    end

    root 'manage/retailers#index'
  end
end
