Solasalonstudios::Application.routes.draw do
  
  root 'welcome#index'

  #resources :locations

  get 'digital-directory/:location_id' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory
  
end
