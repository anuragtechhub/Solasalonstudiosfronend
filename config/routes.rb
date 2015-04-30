Solasalonstudios::Application.routes.draw do

  get "tour/request-a-tour" => 'tour#request_a_tour', :as => :request_a_tour
  get "home" => 'home#index', :as => :home
  root 'home#index'

  get "about-us" => 'about_us#index', :as => :about_us
  get "contact-us" => "contact_us#index", :as => :contact_us
  get "faq" => 'faq#index', :as => :faqs
  get "testimonials" => 'testimonials#index', :as => :testimonials
  get 'gallery' => 'gallery#index', :as => :gallery
  get 'news' => 'news#index', :as => :news
  match "newsletter/sign-up" => 'newsletter#sign_up', :via => [:get, :post], :as => :newsletter_sign_up
  get "own-your-salon" => 'own_your_salon#index', :as => :own_your_salon
  get "request-franchising-info" => "request_franchising_info#index", :as => :request_franchising_info
  match "search/results" => 'search#results', :via => [:get, :post], :as => :search_results

  match 'contact-us-request-a-tour' => 'contact_us#request_a_tour', :via => [:post], :as => :contact_us_request_a_tour

  get "locations" => 'locations#index', :as => :locations
  get "locations/:state" => 'locations#state', :as => :locations_by_state
  get "locations/:state/:city" => 'locations#city', :as => :locations_by_city
  get "locations/:state/:city/:url_name" => 'locations#salon', :as => :salon_location
  get "locations/:state/:city/:url_name/stylists(/:service)" => 'locations#stylists', :as => :salon_stylists
  get "locations-fullscreen" => 'locations#fullscreen', :as => :locations_fullscreen

  get 'salon-professionals' => 'stylists#index', :as => :salon_professionals
  get 'salon-professional/:url_name' => 'stylists#show', :as => :show_salon_professional
  get 'salon-professional/:url_name/send-a-message' => 'stylists#send_a_message', :as => :salon_professional_send_a_message

  get "blog" => 'blog#index', :as => :blog
  get "blog/:url_name" => 'blog#show', :as => :show_blog
  get "blog/category/:category_url_name" => 'blog#index', :as => :blog_category

  get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
end