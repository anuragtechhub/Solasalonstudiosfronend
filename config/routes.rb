Solasalonstudios::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  root 'welcome#index'

  #resources :locations
  #resources :stylists

  get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory
  
end
