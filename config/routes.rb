Solasalonstudios::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  get "home" => 'home#index', :as => :home
  get 'new-cms' => 'home#new_cms'
  root 'home#index'

  get '5000' => 'home#sola_5000', :as => :sola_5000

  get "about-us" => 'about_us#index', :as => :about_us
  get "about" => 'about_us#index'
  
  get "contact-us" => "contact_us#index", :as => :contact_us
  get "contact-us-thank-you" => 'contact_us#thank_you', :as => :contact_us_thank_you
  get 'contact_us' => "contact_us#index"

  get "diversity" => 'diversity#index' , :as => :diversity

  get "faq" => 'faq#index', :as => :faqs
  get "testimonials" => 'testimonials#index', :as => :testimonials
  
  get 'gallery' => 'gallery#index', :as => :gallery
  get 'gallery-photos' => 'gallery#index'

  get 'news' => 'news#index', :as => :news
  match "newsletter/sign-up" => 'newsletter#sign_up', :via => [:get, :post], :as => :newsletter_sign_up
  get "own-your-salon" => 'own_your_salon#index', :as => :own_your_salon
  get "own-your-salon/:tab" => 'own_your_salon#index'
  get 'own' => 'own_your_salon#index'
  get 'own/:tab' => 'own_your_salon#index'
  get 'amenities' => 'own_your_salon#index'
  
  get "request-franchising-info" => "contact_us#index", :as => :request_franchising_info
  get "tour/request-a-tour" => 'contact_us#index', :as => :request_a_tour
  get "rent-a-studio" => 'contact_us#index', :as => :rent_a_studio
  match "franchising-request" => 'contact_us#franchising_request', :via => [:get, :post], :as => :franchising_request
  
  match "search/results" => 'search#results', :via => [:get, :post], :as => :search_results

  match 'contact-us-request-a-tour' => 'contact_us#request_a_tour', :via => [:post], :as => :contact_us_request_a_tour
  match 'partner-inquiry' => 'contact_us#partner_inquiry', :via => [:get, :post], :as => :partner_inquiry

  get "locations" => 'locations#index', :as => :locations
  get "states/:state" => 'locations#state', :as => :locations_by_state
  get "provinces/:state" => 'locations#state', :as => :locations_by_province
  #get "locations/:state/:city" => 'locations#city', :as => :locations_by_city
  
  get "locations/:url_name/salon-professionals(/:service)" => 'locations#stylists', :as => :salon_stylists
  get "locations/:state/:city/:url_name" => 'locations#old_salon', :as => :old_salon_location
  get "locations/:url_name" => 'locations#salon', :as => :salon_location
  get "locations/:url_name/contact-us-success" => 'locations#salon'
  
  get "locations-fullscreen" => 'locations#fullscreen', :as => :locations_fullscreen
  get "stores/:url_name" => 'locations#salon_redirect'
  get "store/:url_name" => 'locations#salon_redirect'

  #match 'mysola' => 'my_sola#index', :via => [:get, :post], :as => :my_sola
  #match 'mysola/s3-presigned-post' => 'mysola#s3_presigned_post', :via => [:post], :as => :s3_presigned_post

  get 'stylist' => 'stylists#index'
  get 'stylists/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name/:url' => 'stylists#redirect'
  get 'salon-professionals' => 'stylists#index', :as => :salon_professionals
  get 'stylistsearch' => 'stylists#index'
  get 'salon-professional/:url_name' => 'stylists#show', :as => :show_salon_professional
  match 'salon-professional-send-a-message' => 'stylists#send_a_message', :via => [:get, :post], :as => :salon_professional_send_a_message

  get "article/:url_name" => 'article#show', :as => :show_article
  get "readmore/:url_name" => 'article#show'

  get "blog" => 'blog#index', :as => :blog
  get "blog/:url_name" => 'blog#show', :as => :show_blog
  get "blog-preview/:url_name" => 'blog#show_preview', :as => :show_blog_preview
  get "blog-readmore/:url_name" => 'blog#show'
  get "blog/category/:category_url_name" => 'blog#index', :as => :blog_category

  get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory

  get 'regions' => 'locations#index'
  get 'region/:url_name' => 'locations#region'
  get 'regions/:url_name' => 'locations#region', :as => :region

  match "forgot-password" => 'forgot_password#form', :via => [:get, :post], :as => :forgot_password_form
  match "forgot-password/reset" => 'forgot_password#reset', :via => [:get, :post], :as => :forgot_password_reset

  match 'sessions' => 'sessions#index', :via => [:get, :post]
  # match 'sessions/denver' => 'sessions#denver', :via => [:get, :post]
  # match 'sessions/minneapolis' => 'sessions#minneapolis', :via => [:get, :post]
  # match 'sessions/orange-county' => 'sessions#orange_county', :via => [:get, :post], :as => :oc_session
  match 'sessions/charlotte' => 'sessions#charlotte', :via => [:get, :post], :as => :charlotte_session
  match 'sessions/dallas' => 'sessions#dallas', :via => [:get, :post], :as => :dallas_session

  namespace :api do
    namespace :v1 do

      match 'locations' => 'locations#index', :via => [:get, :post]
      match 'locations/:id' => 'locations#show', :via => [:get, :post]

    end
  end

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get "/:url_name" => 'redirect#short'
  
end