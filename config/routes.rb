Solasalonstudios::Application.routes.draw do

  devise_for :admins
  #devise_for :admins
  # devise_for :admins
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  root 'welcome#index'

  #resources :locations

  get 'digital-directory/:location_id' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory
  
end
