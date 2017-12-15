Solasalonstudios::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  get "home" => 'home#index', :as => :home
  get 'new-cms' => 'home#new_cms'
  root 'home#index'

  get 'robots.txt' => 'home#robots'
  get 'google575b4ff16cfb013a.html' => 'home#google_verification'
  get 'BingSiteAuth.xml' => 'home#bing_verification'
  get 'sitemap.xml' => 'home#sitemap'
 
  get '5000' => 'home#sola_5000', :as => :sola_5000



  # about URLs
  get "about-us" => 'about_us#index', :as => :about_us
  get "about" => 'about_us#index'
  get "who-we-are" => 'about_us#who_we_are', :as => :who_we_are
  get "leadership" => 'about_us#leadership', :as => :leadership
  get "our-story" => 'about_us#our_story', :as => :our_story 
  get 'leadership/r-randall-clark' => 'about_us#randall_clark', :as => :randall_clark
  get 'leadership/ben-jones' => 'about_us#ben_jones', :as => :ben_jones
  get 'leadership/jennie-wolff' => 'about_us#jennie_wolff', :as => :jennie_wolff
  get 'leadership/myrle-mcneil' => 'about_us#myrle_mcneil', :as => :myrle_mcneil
  get 'leadership/j-todd-neel' => 'about_us#todd_neel', :as => :todd_neel


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
  get 'own/:tab' => 'own_your_salon#index', :as => :own_tab
  get 'amenities' => 'own_your_salon#index'

  get 'privacy-policy' => 'legal#privacy_policy', :as => :privacy_policy
  
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

  # custom location redirects
  get '/locations/6th-avenue' => 'locations#sixthaveredirect', :via => [:get, :post]

  get "locations/:url_name" => 'locations#salon', :as => :salon_location
  get "locations/:url_name/contact-us-success" => 'locations#salon'
  
  get "locations-fullscreen" => 'locations#fullscreen', :as => :locations_fullscreen
  get "stores/:url_name" => 'locations#salon_redirect'
  get "store/:url_name" => 'locations#salon_redirect'

  match 'mysola' => 'my_sola#index', :via => [:get, :post], :as => :my_sola
  match 'mysola/:id' => 'my_sola#show', :via => [:get, :post], :as => :show_my_sola_image
  match 'mysola-s3-presigned-post' => 'my_sola#s3_presigned_post', :via => [:post], :as => :s3_presigned_post
  match 'mysola-image-preview/:id' => 'my_sola#image_preview', :via => [:get, :post], :as => :my_sola_image_preview
  match 'mysola-image-upload' => 'my_sola#image_upload', :via => [:get, :post], :as => :my_sola_image_upload

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
  get 'dd' => 'digital_directory#dd', :via => [:get, :post]
  get 'dd/color' => 'digital_directory#color', :via => [:get, :post]

  get 'regions' => 'locations#index'
  get 'region/:url_name' => 'locations#region'
  get 'regions/:url_name' => 'locations#region', :as => :region

  match "forgot-password" => 'forgot_password#form', :via => [:get, :post], :as => :forgot_password_form
  match "forgot-password/reset" => 'forgot_password#reset', :via => [:get, :post], :as => :forgot_password_reset

  match 'sessions' => 'sessions#index', :via => [:get, :post]
  # match 'sessions/denver' => 'sessions#denver', :via => [:get, :post]
  # match 'sessions/minneapolis' => 'sessions#minneapolis', :via => [:get, :post]
  # match 'sessions/orange-county' => 'sessions#orange_county', :via => [:get, :post], :as => :oc_session
  match 'sessions/charlotte' => 'sessions#index', :via => [:get, :post], :as => :charlotte_session
  match 'sessions/dallas' => 'sessions#index', :via => [:get, :post], :as => :dallas_session
  match 'sessions/dc' => 'sessions#index', :via => [:get, :post], :as => :dc_session
  match 'sessions/west-palm-beach' => 'sessions#west_palm_beach', :via => [:get, :post], :as => :west_palm_beach_session
  match 'sessions/san-jose' => 'sessions#san_jose', :via => [:get, :post], :as => :san_jose_session

  namespace :api do
    namespace :v1 do

      match 'locations' => 'locations#index', :via => [:get, :post]
      match 'locations/:id' => 'locations#show', :via => [:get, :post]

    end
  end

  match '/cms/save-lease' => 'cms#save_lease', :via => [:get, :post], :as => :cms_save_lease
  match '/cms/save-stylist' => 'cms#save_stylist', :via => [:get, :post], :as => :cms_save_stylist

  match '/cms/locations-select' => 'cms#locations_select', :via => [:get, :post], :as => :cms_locations_select
  match '/cms/studios-select' => 'cms#studios_select', :via => [:get, :post], :as => :cms_studios_select
  match '/cms/stylists-select' => 'cms#stylists_select', :via => [:get, :post], :as => :cms_stylists_select

  match '/cms/s3-presigned-post' => 'cms#s3_presigned_post', :via => [:get, :post], :as => :cms_s3_presigned_post

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get "/:url_name" => 'redirect#short'
  
end