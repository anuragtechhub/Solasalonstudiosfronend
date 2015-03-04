Solasalonstudios::Application.routes.draw do

  get "tour/request-a-tour" => 'tour#request_a_tour', :as => :request_a_tour
  get "home" => 'home#index', :as => :home
  root 'home#index'

  get "about-us" => 'about_us#index', :as => :about_us
  get "own-your-salon" => 'own_your_salon#index', :as => :own_your_salon
  match "search/results" => 'search#results', :via => [:get, :post], :as => :search_results

  get "locations" => 'locations#index', :as => :locations
  get "locations/:state" => 'locations#state', :as => :locations_by_state
  get "locations/:state/:city" => 'locations#city', :as => :locations_by_city
  get "locations/:state/:city/:url_name" => 'locations#salon', :as => :salon_location

  get 'stylists' => 'stylists#index', :as => :stylists
  get 'stylists/:url_name' => 'stylists#show', :as => :show_stylist

  get "blog" => 'blog#index', :as => :blog
  get "blog/:url_name" => 'blog#show', :as => :show_blog

  get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
end