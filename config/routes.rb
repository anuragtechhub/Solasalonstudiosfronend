Solasalonstudios::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  get "home" => 'home#index', :as => :home
  root 'home#index'

  get '5000' => 'home#sola_5000', :as => :sola_5000

  get "about-us" => 'about_us#index', :as => :about_us
  get "about" => 'about_us#index'
  
  get "contact-us" => "contact_us#index", :as => :contact_us
  get 'contact_us' => "contact_us#index"

  get "faq" => 'faq#index', :as => :faqs
  get "testimonials" => 'testimonials#index', :as => :testimonials
  
  get 'gallery' => 'gallery#index', :as => :gallery
  get 'gallery-photos' => 'gallery#index'

  get 'news' => 'news#index', :as => :news
  match "newsletter/sign-up" => 'newsletter#sign_up', :via => [:get, :post], :as => :newsletter_sign_up
  get "own-your-salon" => 'own_your_salon#index', :as => :own_your_salon
  get 'own' => 'own_your_salon#index'
  get 'amenities' => 'own_your_salon#index'
  
  get "request-franchising-info" => "contact_us#index", :as => :request_franchising_info
  get "tour/request-a-tour" => 'contact_us#index', :as => :request_a_tour
  get "rent-a-studio" => 'contact_us#index', :as => :rent_a_studio
  match "franchising-request" => 'contact_us#franchising_request', :via => [:get, :post], :as => :franchising_request
  
  match "search/results" => 'search#results', :via => [:get, :post], :as => :search_results

  match 'contact-us-request-a-tour' => 'contact_us#request_a_tour', :via => [:post], :as => :contact_us_request_a_tour
  match 'partner-inquiry' => 'contact_us#partner_inquiry', :via => [:get, :post], :as => :partner_inquiry

  get "locations" => 'locations#index', :as => :locations
  get "locations/:state" => 'locations#state', :as => :locations_by_state
  get "locations/:state/:city" => 'locations#city', :as => :locations_by_city
  get "locations/:state/:city/:url_name" => 'locations#salon', :as => :salon_location
  get "locations/:state/:city/:url_name/salon-professionals(/:service)" => 'locations#stylists', :as => :salon_stylists
  get "locations-fullscreen" => 'locations#fullscreen', :as => :locations_fullscreen

  get 'salon-professionals' => 'stylists#index', :as => :salon_professionals
  get 'stylistsearch' => 'stylists#index'
  get 'salon-professional/:url_name' => 'stylists#show', :as => :show_salon_professional
  match 'salon-professional-send-a-message' => 'stylists#send_a_message', :via => [:get, :post], :as => :salon_professional_send_a_message

  get "article/:url_name" => 'article#show', :as => :show_article
  get "readmore/:url_name" => 'article#show'

  get "blog" => 'blog#index', :as => :blog
  get "blog/:url_name" => 'blog#show', :as => :show_blog
  get "blog-readmore/:url_name" => 'blog#show'
  get "blog/category/:category_url_name" => 'blog#index', :as => :blog_category

  get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory

  get 'regions/:url_name' => 'locations#region', :as => :region

  match "forgot-password" => 'forgot_password#form', :via => [:get, :post], :as => :forgot_password_form
  match "forgot-password/reset" => 'forgot_password#reset', :via => [:get, :post], :as => :forgot_password_reset

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
end