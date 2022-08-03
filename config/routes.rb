# frozen_string_literal: true

Solasalonstudios::Application.routes.draw do
  require 'sidekiq/web'

  devise_for :admins

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  # engines
  mount Franchising::Engine => '/', as: 'franchising_engine', constraints: DomainConstraint.new(ENV.fetch('FRANCHISING_DOMAINS', nil))
  mount Pro::Engine => '/', as: 'pro_engine', constraints: DomainConstraint.new(ENV.fetch('PRO_DOMAINS', nil))
 
  get '/' => 'home#index', :as => :home

  get 'new-cms' => 'home#new_cms'
  root 'home#index'

  get 'robots.txt' => 'home#robots'
  get 'google575b4ff16cfb013a.html' => 'home#google_verification'
  get 'BingSiteAuth.xml' => 'home#bing_verification'
  get 'sitemap.xml' => 'home#sitemap'

  #get '5000' => 'home#sola_5000', :as => :sola_5000
  get 'franchising' => 'home#franchising', as: :franchising

  # About Us URLs

  get 'about-us' => 'about_us#index', :as => :about_us
  get 'about' => 'about_us#index'

  get 'who-we-are' => 'about_us#who_we_are', :as => :who_we_are
  get 'leadership' => 'about_us#leadership', :as => :leadership
  get 'our-story' => 'about_us#our_story', :as => :our_story
  # get 'leadership/r-randall-clark' => 'about_us#randall_clark', :as => :randall_clark
  get 'leadership/rodrigo-miranda' => 'about_us#rodrigo_miranda', :as => :rodrigo_miranda
  # get 'leadership/ben-jones' => 'about_us#ben_jones', :as => :ben_jones
  # get 'leadership/jennie-wolff' => 'about_us#jennie_wolff', :as => :jennie_wolff
  # get 'leadership/myrle-mcneal' => 'about_us#myrle_mcneal', :as => :myrle_mcneal
  # get 'leadership/j-todd-neel' => 'about_us#todd_neel', :as => :todd_neel

  get 'contact-us' => 'contact_us#index', :as => :contact_us
  get 'contact-us/contact-form-success' => 'contact_us#contact_form_success', :as => :contact_us_contact_form_success
  get 'contact-us-thank-you' => 'contact_us#thank_you', :as => :contact_us_thank_you
  get 'contact_us' => 'contact_us#index'

  get 'diversity' => 'diversity#index', :as => :diversity

  get 'faq' => 'faq#index', :as => :faqs
  get 'testimonials' => 'testimonials#index', :as => :testimonials

  get 'gallery' => 'gallery#index', :as => :gallery
  get 'gallery-photos' => 'gallery#index'

  get 'news' => 'news#index', :as => :news
  match 'newsletter/sign-up' => 'newsletter#sign_up', :via => %i[get post], :as => :newsletter_sign_up

  get 'franchise', to: redirect('https://pages.solasalonstudios.com/signup?utm_campaign=entrepreneur_print_ad&utm_source=referral&utm_medium=website', status: 301)

  get 'covid19', to: redirect('https://solasalonstudios-covid19.com/', status: 301), as: :covid19

  # Own Your Salon URLs

  # old own paths
  get 'amenities' => 'own_your_salon#index'
  get 'own-your-salon' => 'own_your_salon#index', :as => :own_your_salon
  get 'own-your-salon/:tab' => 'own_your_salon#index'
  get 'own' => 'own_your_salon#index'
  get 'own/studio-amenities' => 'own_your_salon#studio_amenities'
  get 'own/own-your-salon' => 'own_your_salon#own_your_salon'
  get 'own/sola-pro' => 'own_your_salon#old_sola_pro'
  get 'own/sola-sessions' => 'own_your_salon#old_sola_sessions'
  get 'own/solagenius' => 'own_your_salon#old_solagenius'
  get 'own/:tab' => 'own_your_salon#index', :as => :own_tab

  # current own paths
  get 'our-studios' => 'own_your_salon#our_studios', :as => :our_studios
  get 'sola-pro' => 'own_your_salon#sola_pro', :as => :sola_pro
  get 'sola-sessions' => 'own_your_salon#sola_sessions', :as => :sola_sessions
  get 'solagenius' => 'own_your_salon#solagenius', :as => :solagenius
  get 'why-sola' => 'own_your_salon#why_sola', :as => :why_sola
  get 'why-sola/contact-form-success' => 'own_your_salon#contact_form_success'

  get 'privacy-policy' => 'legal#privacy_policy', :as => :privacy_policy
  get 'accessibility-statement' => 'legal#accessibility_statement', as: :accessibility_statement

  get 'request-franchising-info' => 'contact_us#index', :as => :request_franchising_info
  get 'tour/request-a-tour' => 'contact_us#index', :as => :request_a_tour
  get 'rent-a-studio' => 'contact_us#index', :as => :rent_a_studio
  match 'franchising-request' => 'contact_us#franchising_request', :via => %i[get post], :as => :franchising_request

  match 'search/results' => 'search#results', :via => %i[get post], :as => :search_results

  match 'solagenius/booknow' => 'booknow#landing_page', :via => %i[get post], :as => :booknow_landing_page
  match 'booknow' => 'booknow#search', :via => %i[get post], :as => :booknow_search
  match 'booknow/results(.:format)' => 'booknow#results', :via => %i[get post], :as => :booknow_results
  get 'booknow/cojilio_results' => 'booknow#cojilio_results', :as => :cojilio_results
  match 'booknow/booking-complete' => 'booknow#booking_complete', :via => %i[get post], :as => :booknow_booking_complete
  post 'booknow/save-booknow-booking' => 'booknow#save_booking', :as => :save_booknow_booking

  post 'contact-us-request-a-tour' => 'contact_us#request_a_tour', :as => :contact_us_request_a_tour
  match 'partner-inquiry' => 'contact_us#partner_inquiry', :via => %i[get post], :as => :partner_inquiry

  get 'locations' => 'locations#index', :as => :locations
  get 'states/:state' => 'locations#state', :as => :locations_by_state
  get 'provinces/:state' => 'locations#state', :as => :locations_by_province
  # get "locations/:state/:city" => 'locations#city', :as => :locations_by_city

  get 'locations/:url_name/salon-professionals(/:service)' => 'locations#stylists', :as => :salon_stylists
  get 'locations/:state/:city/:url_name' => 'locations#old_salon', :as => :old_salon_location
  get 'locations/state/:state' => 'locations#state'

  # custom location redirects
  get '/locations/6th-avenue' => 'locations#sixthaveredirect', :via => %i[get post]

  get 'locations/:url_name' => 'locations#salon', :as => :salon_location
  get 'locations/:url_name/contact-form-success' => 'locations#contact_form_success', :as => :location_contact_form_success
  match 'find-salon-location' => 'locations#find_salon', :via => %i[get post], :as => :find_salon_location
  match 'locations-usa' => 'locations#usa', :via => %i[get post], :as => :locations_usa

  get 'locations-fullscreen' => 'locations#fullscreen', :as => :locations_fullscreen
  get 'stores/:url_name' => 'locations#salon_redirect'
  get 'store/:url_name' => 'locations#salon_redirect'

  match 'mysola' => 'my_sola#index', :via => %i[get post], :as => :my_sola
  match 'mysola/:id' => 'my_sola#show', :via => %i[get post], :as => :show_my_sola_image
  post 'mysola-s3-presigned-post' => 'my_sola#s3_presigned_post', :as => :s3_presigned_post
  match 'mysola-image-preview/:id' => 'my_sola#image_preview', :via => %i[get post], :as => :my_sola_image_preview
  match 'mysola-image-upload' => 'my_sola#image_upload', :via => %i[get post], :as => :my_sola_image_upload

  match 'sola10k' => 'sola10k#index', :via => %i[get post], :as => :sola10k
  match 'sola10k/:id' => 'sola10k#show', :via => %i[get post], :as => :show_sola10k_image
  post 'sola10k-s3-presigned-post' => 'sola10k#s3_presigned_post', :as => :sola10ks3_presigned_post
  match 'sola10k-image-preview/:id' => 'sola10k#image_preview', :via => %i[get post], :as => :sola10k_image_preview
  match 'sola10k-image-upload' => 'sola10k#image_upload', :via => %i[get post], :as => :sola10k_image_upload

  get 'stylist' => 'stylists#index'
  get 'stylists/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name/:url' => 'stylists#redirect'
  get 'salon-professionals' => 'stylists#index', :as => :salon_professionals
  get 'findaprofessional' => 'stylists#index', :as => :find_a_professional
  get 'stylistsearch' => 'stylists#index'
  get 'salon-professional/:url_name' => 'stylists#show', :as => :show_salon_professional
  get 'goingindependent' => 'stylists#going_independent', :as => :going_independent
  get 'goingindependent/contact-form-success' => 'stylists#going_independent_contact_form_success', :as => :going_independent_contact_form_success
  match 'salon-professional-send-a-message' => 'stylists#send_a_message', :via => %i[get post], :as => :salon_professional_send_a_message

  get 'financialguide' => 'stylists#financial_guide', :as => :financial_guide
  get 'financialguide/contact-form-success' => 'stylists#financial_guide_contact_form_success', :as => :financial_guide_contact_form_success

  get 'article/:url_name' => 'article#show', :as => :show_article
  get 'readmore/:url_name' => 'article#show'

  get 'blog' => 'blog#index', :as => :blog
  get 'blog/:url_name' => 'blog#show', :as => :show_blog
  get 'blog/:url_name/contact-form-success' => 'blog#contact_form_success'
  get 'blog-preview/:url_name' => 'blog#show_preview', :as => :show_blog_preview
  get 'blog-readmore/:url_name' => 'blog#show'
  get 'blog/category/:category_url_name' => 'blog#index', :as => :blog_category

  # get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory
  # get 'dd' => 'digital_directory#dd', :via => [:get, :post]
  # get 'dd/color' => 'digital_directory#color', :via => [:get, :post]

  get 'regions' => 'locations#index'
  get 'region/:url_name' => 'locations#region'
  get 'regions/:url_name' => 'locations#region', :as => :region

  get 'emails/welcome-to-sola' => 'emails#welcome_to_sola'

  match 'forgot-password' => 'forgot_password#form', :via => %i[get post], :as => :forgot_password_form
  match 'forgot-password/reset' => 'forgot_password#reset', :via => %i[get post], :as => :forgot_password_reset

  match 'sessions' => 'sessions#index', :via => %i[get post]
  match 'sola-sessions/portland' => 'sessions#portland', :via => %i[get post], :as => :portland_session
  # match 'sessions/denver' => 'sessions#denver', :via => [:get, :post]
  # match 'sessions/minneapolis' => 'sessions#minneapolis', :via => [:get, :post]
  # match 'sessions/orange-county' => 'sessions#orange_county', :via => [:get, :post], :as => :oc_session
  # match 'sessions/charlotte' => 'sessions#index', :via => [:get, :post], :as => :charlotte_session
  # match 'sessions/dallas' => 'sessions#index', :via => [:get, :post], :as => :dallas_session
  # match 'sessions/dc' => 'sessions#index', :via => [:get, :post], :as => :dc_session
  # match 'sessions/west-palm-beach' => 'sessions#index', :via => [:get, :post], :as => :west_palm_beach_session
  # match 'sessions/san-jose' => 'sessions#index', :via => [:get, :post], :as => :san_jose_session
  # match 'sessions/chicago' => 'sessions#index', :via => [:get, :post], :as => :chicago_session
  # match 'sessions/san-diego' => 'sessions#san_diego', :via => [:get, :post], :as => :san_diego_session
  # match 'sessions/nashville' => 'sessions#nashville', :via => [:get, :post], :as => :nashville_session

  namespace :api do
    namespace :sola_cms, path: '/' do
      resources :articles
      resources :reports
      resources :blogs
      resources :request_tour_inquiries
      resources :book_now_bookings
      resources :locations
      resources :partner_inquiries
      resources :msas
      resources :my_sola_images
      resources :state_regions
      resources :side_menu_items
      resources :sola10k_images
      resources :stylist_messages
      resources :brands
      resources :class_images
      resources :education_hero_images
      resources :sola_class_regions do 
        collection do 
          get :get_region_and_state
        end 
      end 
      resources :product_informations
      resources :tags
      resources :home_buttons
      resources :categories
      resources :admins
      resources :deals
      resources :events_and_classes
      resources :tools_and_resources
      resources :notifications
      resources :home_buttons
      resources :externals
      resources :home_hero_images
      resources :categories
      resources :rent_manager_units
      resources :videos
      resources :update_my_sola_websites
      resources :testimonials
      resources :stylist_units
      resources :franchising_inquiries
      resources :scheduled_job_logs
      resources :countries
      resources :stylists
      resources :franchise_articles
      resources :maintenance_contacts
      resources :gloss_genius_logs
      resources :callfire_logs, only: [:index]
      resources :events
    end

    namespace :v1 do
      match 'locations' => 'locations#index', :via => %i[get post]
      match 'locations/:id' => 'locations#show', :via => %i[get post]
    end

    namespace :v2 do
      match 'locations' => 'locations#index', :via => %i[get post]
      match 'locations/:id' => 'locations#show', :via => %i[get post]
      resources :locations do 
        member do
          get 'get_location_data'
        end
      end  
    end

    namespace :v3 do
      resources :hubspot_webhooks, only: %i[create]
      resources :rent_manager_webhooks, only: %i[create]
    end
  end

  match '/cms/save-lease' => 'cms#save_lease', :via => %i[get post], :as => :cms_save_lease
  match '/cms/save-stylist' => 'cms#save_stylist', :via => %i[get post], :as => :cms_save_stylist

  match '/cms/locations-select' => 'cms#locations_select', :via => %i[get post], :as => :cms_locations_select
  match '/cms/studios-select' => 'cms#studios_select', :via => %i[get post], :as => :cms_studios_select
  match '/cms/stylists-select' => 'cms#stylists_select', :via => %i[get post], :as => :cms_stylists_select

  match '/cms/s3-presigned-post' => 'cms#s3_presigned_post', :via => %i[get post], :as => :cms_s3_presigned_post

  # Brazil URLs
  match '/sejasola' => 'brazil#sejasola', :via => %i[get post], :as => :sejasola

  get '/:url_name' => 'redirect#short'
end

# == Route Map
#
#                                   Prefix Verb     URI Pattern                                                   Controller#Action
#                        new_admin_session GET      /admins/sign_in(.:format)                                     devise/sessions#new
#                            admin_session POST     /admins/sign_in(.:format)                                     devise/sessions#create
#                    destroy_admin_session DELETE   /admins/sign_out(.:format)                                    devise/sessions#destroy
#                           admin_password POST     /admins/password(.:format)                                    devise/passwords#create
#                       new_admin_password GET      /admins/password/new(.:format)                                devise/passwords#new
#                      edit_admin_password GET      /admins/password/edit(.:format)                               devise/passwords#edit
#                                          PATCH    /admins/password(.:format)                                    devise/passwords#update
#                                          PUT      /admins/password(.:format)                                    devise/passwords#update
#                cancel_admin_registration GET      /admins/cancel(.:format)                                      devise/registrations#cancel
#                       admin_registration POST     /admins(.:format)                                             devise/registrations#create
#                   new_admin_registration GET      /admins/sign_up(.:format)                                     devise/registrations#new
#                  edit_admin_registration GET      /admins/edit(.:format)                                        devise/registrations#edit
#                                          PATCH    /admins(.:format)                                             devise/registrations#update
#                                          PUT      /admins(.:format)                                             devise/registrations#update
#                                          DELETE   /admins(.:format)                                             devise/registrations#destroy
#                              sidekiq_web          /sidekiq                                                      Sidekiq::Web
#                              rails_admin          /admin                                                        RailsAdmin::Engine
#                       franchising_engine          /                                                             Franchising::Engine
#                               pro_engine          /                                                             Pro::Engine
#                                     home GET      /                                                             home#index
#                                  new_cms GET      /new-cms(.:format)                                            home#new_cms
#                                     root GET      /                                                             home#index
#                                          GET      /robots.txt(.:format)                                         home#robots
#                                          GET      /google575b4ff16cfb013a.html(.:format)                        home#google_verification
#                                          GET      /BingSiteAuth.xml(.:format)                                   home#bing_verification
#                                          GET      /sitemap.xml(.:format)                                        home#sitemap
#                              franchising GET      /franchising(.:format)                                        home#franchising
#                                 about_us GET      /about-us(.:format)                                           about_us#index
#                                    about GET      /about(.:format)                                              about_us#index
#                               who_we_are GET      /who-we-are(.:format)                                         about_us#who_we_are
#                               leadership GET      /leadership(.:format)                                         about_us#leadership
#                                our_story GET      /our-story(.:format)                                          about_us#our_story
#                          rodrigo_miranda GET      /leadership/rodrigo-miranda(.:format)                         about_us#rodrigo_miranda
#                               contact_us GET      /contact-us(.:format)                                         contact_us#index
#          contact_us_contact_form_success GET      /contact-us/contact-form-success(.:format)                    contact_us#contact_form_success
#                     contact_us_thank_you GET      /contact-us-thank-you(.:format)                               contact_us#thank_you
#                                          GET      /contact_us(.:format)                                         contact_us#index
#                                diversity GET      /diversity(.:format)                                          diversity#index
#                                     faqs GET      /faq(.:format)                                                faq#index
#                             testimonials GET      /testimonials(.:format)                                       testimonials#index
#                                  gallery GET      /gallery(.:format)                                            gallery#index
#                           gallery_photos GET      /gallery-photos(.:format)                                     gallery#index
#                                     news GET      /news(.:format)                                               news#index
#                       newsletter_sign_up GET|POST /newsletter/sign-up(.:format)                                 newsletter#sign_up
#                                franchise GET      /franchise(.:format)                                          redirect(301, https://pages.solasalonstudios.com/signup?utm_campaign=entrepreneur_print_ad&utm_source=referral&utm_medium=website)
#                                  covid19 GET      /covid19(.:format)                                            redirect(301, https://solasalonstudios-covid19.com/)
#                                amenities GET      /amenities(.:format)                                          own_your_salon#index
#                           own_your_salon GET      /own-your-salon(.:format)                                     own_your_salon#index
#                                          GET      /own-your-salon/:tab(.:format)                                own_your_salon#index
#                                      own GET      /own(.:format)                                                own_your_salon#index
#                     own_studio_amenities GET      /own/studio-amenities(.:format)                               own_your_salon#studio_amenities
#                       own_own_your_salon GET      /own/own-your-salon(.:format)                                 own_your_salon#own_your_salon
#                             own_sola_pro GET      /own/sola-pro(.:format)                                       own_your_salon#old_sola_pro
#                        own_sola_sessions GET      /own/sola-sessions(.:format)                                  own_your_salon#old_sola_sessions
#                           own_solagenius GET      /own/solagenius(.:format)                                     own_your_salon#old_solagenius
#                                  own_tab GET      /own/:tab(.:format)                                           own_your_salon#index
#                              our_studios GET      /our-studios(.:format)                                        own_your_salon#our_studios
#                                 sola_pro GET      /sola-pro(.:format)                                           own_your_salon#sola_pro
#                            sola_sessions GET      /sola-sessions(.:format)                                      own_your_salon#sola_sessions
#                               solagenius GET      /solagenius(.:format)                                         own_your_salon#solagenius
#                                 why_sola GET      /why-sola(.:format)                                           own_your_salon#why_sola
#            why_sola_contact_form_success GET      /why-sola/contact-form-success(.:format)                      own_your_salon#contact_form_success
#                           privacy_policy GET      /privacy-policy(.:format)                                     legal#privacy_policy
#                  accessibility_statement GET      /accessibility-statement(.:format)                            legal#accessibility_statement
#                 request_franchising_info GET      /request-franchising-info(.:format)                           contact_us#index
#                           request_a_tour GET      /tour/request-a-tour(.:format)                                contact_us#index
#                            rent_a_studio GET      /rent-a-studio(.:format)                                      contact_us#index
#                      franchising_request GET|POST /franchising-request(.:format)                                contact_us#franchising_request
#                           search_results GET|POST /search/results(.:format)                                     search#results
#                     booknow_landing_page GET|POST /solagenius/booknow(.:format)                                 booknow#landing_page
#                           booknow_search GET|POST /booknow(.:format)                                            booknow#search
#                          booknow_results GET|POST /booknow/results(.:format)                                    booknow#results
#                          cojilio_results GET      /booknow/cojilio_results(.:format)                            booknow#cojilio_results
#                 booknow_booking_complete GET|POST /booknow/booking-complete(.:format)                           booknow#booking_complete
#                     save_booknow_booking POST     /booknow/save-booknow-booking(.:format)                       booknow#save_booking
#                contact_us_request_a_tour POST     /contact-us-request-a-tour(.:format)                          contact_us#request_a_tour
#                          partner_inquiry GET|POST /partner-inquiry(.:format)                                    contact_us#partner_inquiry
#                                locations GET      /locations(.:format)                                          locations#index
#                       locations_by_state GET      /states/:state(.:format)                                      locations#state
#                    locations_by_province GET      /provinces/:state(.:format)                                   locations#state
#                           salon_stylists GET      /locations/:url_name/salon-professionals(/:service)(.:format) locations#stylists
#                       old_salon_location GET      /locations/:state/:city/:url_name(.:format)                   locations#old_salon
#                                          GET      /locations/state/:state(.:format)                             locations#state
#                     locations_6th_avenue GET      /locations/6th-avenue(.:format)                               locations#sixthaveredirect
#                           salon_location GET      /locations/:url_name(.:format)                                locations#salon
#            location_contact_form_success GET      /locations/:url_name/contact-form-success(.:format)           locations#contact_form_success
#                      find_salon_location GET|POST /find-salon-location(.:format)                                locations#find_salon
#                            locations_usa GET|POST /locations-usa(.:format)                                      locations#usa
#                     locations_fullscreen GET      /locations-fullscreen(.:format)                               locations#fullscreen
#                                          GET      /stores/:url_name(.:format)                                   locations#salon_redirect
#                                          GET      /store/:url_name(.:format)                                    locations#salon_redirect
#                                  my_sola GET|POST /mysola(.:format)                                             my_sola#index
#                       show_my_sola_image GET|POST /mysola/:id(.:format)                                         my_sola#show
#                        s3_presigned_post POST     /mysola-s3-presigned-post(.:format)                           my_sola#s3_presigned_post
#                    my_sola_image_preview GET|POST /mysola-image-preview/:id(.:format)                           my_sola#image_preview
#                     my_sola_image_upload GET|POST /mysola-image-upload(.:format)                                my_sola#image_upload
#                                  sola10k GET|POST /sola10k(.:format)                                            sola10k#index
#                       show_sola10k_image GET|POST /sola10k/:id(.:format)                                        sola10k#show
#                 sola10ks3_presigned_post POST     /sola10k-s3-presigned-post(.:format)                          sola10k#s3_presigned_post
#                    sola10k_image_preview GET|POST /sola10k-image-preview/:id(.:format)                          sola10k#image_preview
#                     sola10k_image_upload GET|POST /sola10k-image-upload(.:format)                               sola10k#image_upload
#                                  stylist GET      /stylist(.:format)                                            stylists#index
#                                          GET      /stylists/:url_name(.:format)                                 stylists#redirect
#                                          GET      /stylist/:url_name(.:format)                                  stylists#redirect
#                                          GET      /stylist/:url_name/:url(.:format)                             stylists#redirect
#                      salon_professionals GET      /salon-professionals(.:format)                                stylists#index
#                      find_a_professional GET      /findaprofessional(.:format)                                  stylists#index
#                            stylistsearch GET      /stylistsearch(.:format)                                      stylists#index
#                  show_salon_professional GET      /salon-professional/:url_name(.:format)                       stylists#show
#                        going_independent GET      /goingindependent(.:format)                                   stylists#going_independent
#   going_independent_contact_form_success GET      /goingindependent/contact-form-success(.:format)              stylists#going_independent_contact_form_success
#        salon_professional_send_a_message GET|POST /salon-professional-send-a-message(.:format)                  stylists#send_a_message
#                          financial_guide GET      /financialguide(.:format)                                     stylists#financial_guide
#     financial_guide_contact_form_success GET      /financialguide/contact-form-success(.:format)                stylists#financial_guide_contact_form_success
#                             show_article GET      /article/:url_name(.:format)                                  article#show
#                                          GET      /readmore/:url_name(.:format)                                 article#show
#                                     blog GET      /blog(.:format)                                               blog#index
#                                show_blog GET      /blog/:url_name(.:format)                                     blog#show
#                                          GET      /blog/:url_name/contact-form-success(.:format)                blog#contact_form_success
#                        show_blog_preview GET      /blog-preview/:url_name(.:format)                             blog#show_preview
#                                          GET      /blog-readmore/:url_name(.:format)                            blog#show
#                            blog_category GET      /blog/category/:category_url_name(.:format)                   blog#index
#                                  regions GET      /regions(.:format)                                            locations#index
#                                          GET      /region/:url_name(.:format)                                   locations#region
#                                   region GET      /regions/:url_name(.:format)                                  locations#region
#                   emails_welcome_to_sola GET      /emails/welcome-to-sola(.:format)                             emails#welcome_to_sola
#                     forgot_password_form GET|POST /forgot-password(.:format)                                    forgot_password#form
#                    forgot_password_reset GET|POST /forgot-password/reset(.:format)                              forgot_password#reset
#                                 sessions GET|POST /sessions(.:format)                                           sessions#index
#                         portland_session GET|POST /sola-sessions/portland(.:format)                             sessions#portland
#                    api_sola_cms_articles GET      /api/articles(.:format)                                       api/sola_cms/articles#index
#                                          POST     /api/articles(.:format)                                       api/sola_cms/articles#create
#                 new_api_sola_cms_article GET      /api/articles/new(.:format)                                   api/sola_cms/articles#new
#                edit_api_sola_cms_article GET      /api/articles/:id/edit(.:format)                              api/sola_cms/articles#edit
#                     api_sola_cms_article GET      /api/articles/:id(.:format)                                   api/sola_cms/articles#show
#                                          PATCH    /api/articles/:id(.:format)                                   api/sola_cms/articles#update
#                                          PUT      /api/articles/:id(.:format)                                   api/sola_cms/articles#update
#                                          DELETE   /api/articles/:id(.:format)                                   api/sola_cms/articles#destroy
#                       api_sola_cms_blogs GET      /api/blogs(.:format)                                          api/sola_cms/blogs#index
#                                          POST     /api/blogs(.:format)                                          api/sola_cms/blogs#create
#                    new_api_sola_cms_blog GET      /api/blogs/new(.:format)                                      api/sola_cms/blogs#new
#                   edit_api_sola_cms_blog GET      /api/blogs/:id/edit(.:format)                                 api/sola_cms/blogs#edit
#                        api_sola_cms_blog GET      /api/blogs/:id(.:format)                                      api/sola_cms/blogs#show
#                                          PATCH    /api/blogs/:id(.:format)                                      api/sola_cms/blogs#update
#                                          PUT      /api/blogs/:id(.:format)                                      api/sola_cms/blogs#update
#                                          DELETE   /api/blogs/:id(.:format)                                      api/sola_cms/blogs#destroy
#      api_sola_cms_request_tour_inquiries GET      /api/request_tour_inquiries(.:format)                         api/sola_cms/request_tour_inquiries#index
#                                          POST     /api/request_tour_inquiries(.:format)                         api/sola_cms/request_tour_inquiries#create
#    new_api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/new(.:format)                     api/sola_cms/request_tour_inquiries#new
#   edit_api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/:id/edit(.:format)                api/sola_cms/request_tour_inquiries#edit
#        api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#show
#                                          PATCH    /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#update
#                                          PUT      /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#update
#                                          DELETE   /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#destroy
#                   api_sola_cms_locations GET      /api/locations(.:format)                                      api/sola_cms/locations#index
#                                          POST     /api/locations(.:format)                                      api/sola_cms/locations#create
#                new_api_sola_cms_location GET      /api/locations/new(.:format)                                  api/sola_cms/locations#new
#               edit_api_sola_cms_location GET      /api/locations/:id/edit(.:format)                             api/sola_cms/locations#edit
#                    api_sola_cms_location GET      /api/locations/:id(.:format)                                  api/sola_cms/locations#show
#                                          PATCH    /api/locations/:id(.:format)                                  api/sola_cms/locations#update
#                                          PUT      /api/locations/:id(.:format)                                  api/sola_cms/locations#update
#                                          DELETE   /api/locations/:id(.:format)                                  api/sola_cms/locations#destroy
#           api_sola_cms_partner_inquiries GET      /api/partner_inquiries(.:format)                              api/sola_cms/partner_inquiries#index
#                                          POST     /api/partner_inquiries(.:format)                              api/sola_cms/partner_inquiries#create
#         new_api_sola_cms_partner_inquiry GET      /api/partner_inquiries/new(.:format)                          api/sola_cms/partner_inquiries#new
#        edit_api_sola_cms_partner_inquiry GET      /api/partner_inquiries/:id/edit(.:format)                     api/sola_cms/partner_inquiries#edit
#             api_sola_cms_partner_inquiry GET      /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#show
#                                          PATCH    /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#update
#                                          PUT      /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#update
#                                          DELETE   /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#destroy
#                        api_sola_cms_msas GET      /api/msas(.:format)                                           api/sola_cms/msas#index
#                                          POST     /api/msas(.:format)                                           api/sola_cms/msas#create
#                     new_api_sola_cms_msa GET      /api/msas/new(.:format)                                       api/sola_cms/msas#new
#                    edit_api_sola_cms_msa GET      /api/msas/:id/edit(.:format)                                  api/sola_cms/msas#edit
#                         api_sola_cms_msa GET      /api/msas/:id(.:format)                                       api/sola_cms/msas#show
#                                          PATCH    /api/msas/:id(.:format)                                       api/sola_cms/msas#update
#                                          PUT      /api/msas/:id(.:format)                                       api/sola_cms/msas#update
#                                          DELETE   /api/msas/:id(.:format)                                       api/sola_cms/msas#destroy
#              api_sola_cms_my_sola_images GET      /api/my_sola_images(.:format)                                 api/sola_cms/my_sola_images#index
#                                          POST     /api/my_sola_images(.:format)                                 api/sola_cms/my_sola_images#create
#           new_api_sola_cms_my_sola_image GET      /api/my_sola_images/new(.:format)                             api/sola_cms/my_sola_images#new
#          edit_api_sola_cms_my_sola_image GET      /api/my_sola_images/:id/edit(.:format)                        api/sola_cms/my_sola_images#edit
#               api_sola_cms_my_sola_image GET      /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#show
#                                          PATCH    /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#update
#                                          PUT      /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#update
#                                          DELETE   /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#destroy
#               api_sola_cms_state_regions GET      /api/state_regions(.:format)                                  api/sola_cms/state_regions#index
#                                          POST     /api/state_regions(.:format)                                  api/sola_cms/state_regions#create
#            new_api_sola_cms_state_region GET      /api/state_regions/new(.:format)                              api/sola_cms/state_regions#new
#           edit_api_sola_cms_state_region GET      /api/state_regions/:id/edit(.:format)                         api/sola_cms/state_regions#edit
#                api_sola_cms_state_region GET      /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#show
#                                          PATCH    /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#update
#                                          PUT      /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#update
#                                          DELETE   /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#destroy
#             api_sola_cms_side_menu_items GET      /api/side_menu_items(.:format)                                api/sola_cms/side_menu_items#index
#                                          POST     /api/side_menu_items(.:format)                                api/sola_cms/side_menu_items#create
#          new_api_sola_cms_side_menu_item GET      /api/side_menu_items/new(.:format)                            api/sola_cms/side_menu_items#new
#         edit_api_sola_cms_side_menu_item GET      /api/side_menu_items/:id/edit(.:format)                       api/sola_cms/side_menu_items#edit
#              api_sola_cms_side_menu_item GET      /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#show
#                                          PATCH    /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#update
#                                          PUT      /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#update
#                                          DELETE   /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#destroy
#              api_sola_cms_sola10k_images GET      /api/sola10k_images(.:format)                                 api/sola_cms/sola10k_images#index
#                                          POST     /api/sola10k_images(.:format)                                 api/sola_cms/sola10k_images#create
#           new_api_sola_cms_sola10k_image GET      /api/sola10k_images/new(.:format)                             api/sola_cms/sola10k_images#new
#          edit_api_sola_cms_sola10k_image GET      /api/sola10k_images/:id/edit(.:format)                        api/sola_cms/sola10k_images#edit
#               api_sola_cms_sola10k_image GET      /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#show
#                                          PATCH    /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#update
#                                          PUT      /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#update
#                                          DELETE   /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#destroy
#            api_sola_cms_stylist_messages GET      /api/stylist_messages(.:format)                               api/sola_cms/stylist_messages#index
#                                          POST     /api/stylist_messages(.:format)                               api/sola_cms/stylist_messages#create
#         new_api_sola_cms_stylist_message GET      /api/stylist_messages/new(.:format)                           api/sola_cms/stylist_messages#new
#        edit_api_sola_cms_stylist_message GET      /api/stylist_messages/:id/edit(.:format)                      api/sola_cms/stylist_messages#edit
#             api_sola_cms_stylist_message GET      /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#show
#                                          PATCH    /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#update
#                                          PUT      /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#update
#                                          DELETE   /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#destroy
#                      api_sola_cms_brands GET      /api/brands(.:format)                                         api/sola_cms/brands#index
#                                          POST     /api/brands(.:format)                                         api/sola_cms/brands#create
#                   new_api_sola_cms_brand GET      /api/brands/new(.:format)                                     api/sola_cms/brands#new
#                  edit_api_sola_cms_brand GET      /api/brands/:id/edit(.:format)                                api/sola_cms/brands#edit
#                       api_sola_cms_brand GET      /api/brands/:id(.:format)                                     api/sola_cms/brands#show
#                                          PATCH    /api/brands/:id(.:format)                                     api/sola_cms/brands#update
#                                          PUT      /api/brands/:id(.:format)                                     api/sola_cms/brands#update
#                                          DELETE   /api/brands/:id(.:format)                                     api/sola_cms/brands#destroy
#       api_sola_cms_education_hero_images GET      /api/education_hero_images(.:format)                          api/sola_cms/education_hero_images#index
#                                          POST     /api/education_hero_images(.:format)                          api/sola_cms/education_hero_images#create
#    new_api_sola_cms_education_hero_image GET      /api/education_hero_images/new(.:format)                      api/sola_cms/education_hero_images#new
#   edit_api_sola_cms_education_hero_image GET      /api/education_hero_images/:id/edit(.:format)                 api/sola_cms/education_hero_images#edit
#        api_sola_cms_education_hero_image GET      /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#show
#                                          PATCH    /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#update
#                                          PUT      /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#update
#                                          DELETE   /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#destroy
#        api_sola_cms_product_informations GET      /api/product_informations(.:format)                           api/sola_cms/product_informations#index
#                                          POST     /api/product_informations(.:format)                           api/sola_cms/product_informations#create
#     new_api_sola_cms_product_information GET      /api/product_informations/new(.:format)                       api/sola_cms/product_informations#new
#    edit_api_sola_cms_product_information GET      /api/product_informations/:id/edit(.:format)                  api/sola_cms/product_informations#edit
#         api_sola_cms_product_information GET      /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#show
#                                          PATCH    /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#update
#                                          PUT      /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#update
#                                          DELETE   /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#destroy
#         api_sola_cms_tools_and_resources GET      /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#index
#                                          POST     /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#create
#      new_api_sola_cms_tools_and_resource GET      /api/tools_and_resources/new(.:format)                        api/sola_cms/tools_and_resources#new
#     edit_api_sola_cms_tools_and_resource GET      /api/tools_and_resources/:id/edit(.:format)                   api/sola_cms/tools_and_resources#edit
#          api_sola_cms_tools_and_resource GET      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#show
#                                          PATCH    /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                          PUT      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                          DELETE   /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#destroy
#                api_sola_cms_home_buttons GET      /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#index
#                                          POST     /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#create
#             new_api_sola_cms_home_button GET      /api/home_buttons/new(.:format)                               api/sola_cms/home_buttons#new
#            edit_api_sola_cms_home_button GET      /api/home_buttons/:id/edit(.:format)                          api/sola_cms/home_buttons#edit
#                 api_sola_cms_home_button GET      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#show
#                                          PATCH    /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                          PUT      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                          DELETE   /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#destroy
#                      api_sola_cms_admins GET      /api/admins(.:format)                                         api/sola_cms/admins#index
#                                          POST     /api/admins(.:format)                                         api/sola_cms/admins#create
#                   new_api_sola_cms_admin GET      /api/admins/new(.:format)                                     api/sola_cms/admins#new
#                  edit_api_sola_cms_admin GET      /api/admins/:id/edit(.:format)                                api/sola_cms/admins#edit
#                       api_sola_cms_admin GET      /api/admins/:id(.:format)                                     api/sola_cms/admins#show
#                                          PATCH    /api/admins/:id(.:format)                                     api/sola_cms/admins#update
#                                          PUT      /api/admins/:id(.:format)                                     api/sola_cms/admins#update
#                                          DELETE   /api/admins/:id(.:format)                                     api/sola_cms/admins#destroy
#                       api_sola_cms_deals GET      /api/deals(.:format)                                          api/sola_cms/deals#index
#                                          POST     /api/deals(.:format)                                          api/sola_cms/deals#create
#                    new_api_sola_cms_deal GET      /api/deals/new(.:format)                                      api/sola_cms/deals#new
#                   edit_api_sola_cms_deal GET      /api/deals/:id/edit(.:format)                                 api/sola_cms/deals#edit
#                        api_sola_cms_deal GET      /api/deals/:id(.:format)                                      api/sola_cms/deals#show
#                                          PATCH    /api/deals/:id(.:format)                                      api/sola_cms/deals#update
#                                          PUT      /api/deals/:id(.:format)                                      api/sola_cms/deals#update
#                                          DELETE   /api/deals/:id(.:format)                                      api/sola_cms/deals#destroy
#          api_sola_cms_events_and_classes GET      /api/events_and_classes(.:format)                             api/sola_cms/events_and_classes#index
#                                          POST     /api/events_and_classes(.:format)                             api/sola_cms/events_and_classes#create
#        new_api_sola_cms_events_and_class GET      /api/events_and_classes/new(.:format)                         api/sola_cms/events_and_classes#new
#       edit_api_sola_cms_events_and_class GET      /api/events_and_classes/:id/edit(.:format)                    api/sola_cms/events_and_classes#edit
#            api_sola_cms_events_and_class GET      /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#show
#                                          PATCH    /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#update
#                                          PUT      /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#update
#                                          DELETE   /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#destroy
#                                          GET      /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#index
#                                          POST     /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#create
#                                          GET      /api/tools_and_resources/new(.:format)                        api/sola_cms/tools_and_resources#new
#                                          GET      /api/tools_and_resources/:id/edit(.:format)                   api/sola_cms/tools_and_resources#edit
#                                          GET      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#show
#                                          PATCH    /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                          PUT      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                          DELETE   /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#destroy
#               api_sola_cms_notifications GET      /api/notifications(.:format)                                  api/sola_cms/notifications#index
#                                          POST     /api/notifications(.:format)                                  api/sola_cms/notifications#create
#            new_api_sola_cms_notification GET      /api/notifications/new(.:format)                              api/sola_cms/notifications#new
#           edit_api_sola_cms_notification GET      /api/notifications/:id/edit(.:format)                         api/sola_cms/notifications#edit
#                api_sola_cms_notification GET      /api/notifications/:id(.:format)                              api/sola_cms/notifications#show
#                                          PATCH    /api/notifications/:id(.:format)                              api/sola_cms/notifications#update
#                                          PUT      /api/notifications/:id(.:format)                              api/sola_cms/notifications#update
#                                          DELETE   /api/notifications/:id(.:format)                              api/sola_cms/notifications#destroy
#                                          GET      /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#index
#                                          POST     /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#create
#                                          GET      /api/home_buttons/new(.:format)                               api/sola_cms/home_buttons#new
#                                          GET      /api/home_buttons/:id/edit(.:format)                          api/sola_cms/home_buttons#edit
#                                          GET      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#show
#                                          PATCH    /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                          PUT      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                          DELETE   /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#destroy
#                      api_sola_cms_videos GET      /api/videos(.:format)                                         api/sola_cms/videos#index
#                                          POST     /api/videos(.:format)                                         api/sola_cms/videos#create
#                   new_api_sola_cms_video GET      /api/videos/new(.:format)                                     api/sola_cms/videos#new
#                  edit_api_sola_cms_video GET      /api/videos/:id/edit(.:format)                                api/sola_cms/videos#edit
#                       api_sola_cms_video GET      /api/videos/:id(.:format)                                     api/sola_cms/videos#show
#                                          PATCH    /api/videos/:id(.:format)                                     api/sola_cms/videos#update
#                                          PUT      /api/videos/:id(.:format)                                     api/sola_cms/videos#update
#                                          DELETE   /api/videos/:id(.:format)                                     api/sola_cms/videos#destroy
#      api_sola_cms_update_my_sola_website GET      /api/update_my_sola_websites/:id(.:format)                    api/sola_cms/update_my_sola_websites#show
#                                          PATCH    /api/update_my_sola_websites/:id(.:format)                    api/sola_cms/update_my_sola_websites#update
#                                          PUT      /api/update_my_sola_websites/:id(.:format)                    api/sola_cms/update_my_sola_websites#update
#                                          DELETE   /api/update_my_sola_websites/:id(.:format)                    api/sola_cms/update_my_sola_websites#destroy
#  api_sola_cms_listing_of_pending_records GET      /api/listing_of_pending_records(.:format)                     api/sola_cms#listing_of_pending_records
# api_sola_cms_listing_of_approved_records GET      /api/listing_of_approved_records(.:format)                    api/sola_cms#listing_of_approved_records
#                         api_v1_locations GET|POST /api/v1/locations(.:format)                                   api/v1/locations#index
#                                   api_v1 GET|POST /api/v1/locations/:id(.:format)                               api/v1/locations#show
#                         api_v2_locations GET|POST /api/v2/locations(.:format)                                   api/v2/locations#index
#                                   api_v2 GET|POST /api/v2/locations/:id(.:format)                               api/v2/locations#show
#        get_location_data_api_v2_location GET      /api/v2/locations/:id/get_location_data(.:format)             api/v2/locations#get_location_data
#                                          GET      /api/v2/locations(.:format)                                   api/v2/locations#index
#                                          POST     /api/v2/locations(.:format)                                   api/v2/locations#create
#                      new_api_v2_location GET      /api/v2/locations/new(.:format)                               api/v2/locations#new
#                     edit_api_v2_location GET      /api/v2/locations/:id/edit(.:format)                          api/v2/locations#edit
#                          api_v2_location GET      /api/v2/locations/:id(.:format)                               api/v2/locations#show
#                                          PATCH    /api/v2/locations/:id(.:format)                               api/v2/locations#update
#                                          PUT      /api/v2/locations/:id(.:format)                               api/v2/locations#update
#                                          DELETE   /api/v2/locations/:id(.:format)                               api/v2/locations#destroy
#                  api_v3_hubspot_webhooks POST     /api/v3/hubspot_webhooks(.:format)                            api/v3/hubspot_webhooks#create
#             api_v3_rent_manager_webhooks POST     /api/v3/rent_manager_webhooks(.:format)                       api/v3/rent_manager_webhooks#create
#                           cms_save_lease GET|POST /cms/save-lease(.:format)                                     cms#save_lease
#                         cms_save_stylist GET|POST /cms/save-stylist(.:format)                                   cms#save_stylist
#                     cms_locations_select GET|POST /cms/locations-select(.:format)                               cms#locations_select
#                       cms_studios_select GET|POST /cms/studios-select(.:format)                                 cms#studios_select
#                      cms_stylists_select GET|POST /cms/stylists-select(.:format)                                cms#stylists_select
#                    cms_s3_presigned_post GET|POST /cms/s3-presigned-post(.:format)                              cms#s3_presigned_post
#                                 sejasola GET|POST /sejasola(.:format)                                           brazil#sejasola
#                                          GET      /:url_name(.:format)                                          redirect#short
#                           sendgrid_event POST     /sendgrid/event(.:format)                                     gridhook/events#create
#                                 Prefix Verb     URI Pattern                                                   Controller#Action
#                      new_admin_session GET      /admins/sign_in(.:format)                                     devise/sessions#new
#                          admin_session POST     /admins/sign_in(.:format)                                     devise/sessions#create
#                  destroy_admin_session DELETE   /admins/sign_out(.:format)                                    devise/sessions#destroy
#                         admin_password POST     /admins/password(.:format)                                    devise/passwords#create
#                     new_admin_password GET      /admins/password/new(.:format)                                devise/passwords#new
#                    edit_admin_password GET      /admins/password/edit(.:format)                               devise/passwords#edit
#                                        PATCH    /admins/password(.:format)                                    devise/passwords#update
#                                        PUT      /admins/password(.:format)                                    devise/passwords#update
#              cancel_admin_registration GET      /admins/cancel(.:format)                                      devise/registrations#cancel
#                     admin_registration POST     /admins(.:format)                                             devise/registrations#create
#                 new_admin_registration GET      /admins/sign_up(.:format)                                     devise/registrations#new
#                edit_admin_registration GET      /admins/edit(.:format)                                        devise/registrations#edit
#                                        PATCH    /admins(.:format)                                             devise/registrations#update
#                                        PUT      /admins(.:format)                                             devise/registrations#update
#                                        DELETE   /admins(.:format)                                             devise/registrations#destroy
#                            sidekiq_web          /sidekiq                                                      Sidekiq::Web
#                            rails_admin          /admin                                                        RailsAdmin::Engine
#                     franchising_engine          /                                                             Franchising::Engine
#                                    pro          /                                                             Pro::Engine
#                             pro_engine          /                                                             Pro::Engine
#                                   home GET      /                                                             home#index
#                                new_cms GET      /new-cms(.:format)                                            home#new_cms
#                                   root GET      /                                                             home#index
#                                        GET      /robots.txt(.:format)                                         home#robots
#                                        GET      /google575b4ff16cfb013a.html(.:format)                        home#google_verification
#                                        GET      /BingSiteAuth.xml(.:format)                                   home#bing_verification
#                                        GET      /sitemap.xml(.:format)                                        home#sitemap
#                               about_us GET      /about-us(.:format)                                           about_us#index
#                                  about GET      /about(.:format)                                              about_us#index
#                             who_we_are GET      /who-we-are(.:format)                                         about_us#who_we_are
#                             leadership GET      /leadership(.:format)                                         about_us#leadership
#                              our_story GET      /our-story(.:format)                                          about_us#our_story
#                        rodrigo_miranda GET      /leadership/rodrigo-miranda(.:format)                         about_us#rodrigo_miranda
#                             contact_us GET      /contact-us(.:format)                                         contact_us#index
#        contact_us_contact_form_success GET      /contact-us/contact-form-success(.:format)                    contact_us#contact_form_success
#                   contact_us_thank_you GET      /contact-us-thank-you(.:format)                               contact_us#thank_you
#                                        GET      /contact_us(.:format)                                         contact_us#index
#                              diversity GET      /diversity(.:format)                                          diversity#index
#                                   faqs GET      /faq(.:format)                                                faq#index
#                           testimonials GET      /testimonials(.:format)                                       testimonials#index
#                                gallery GET      /gallery(.:format)                                            gallery#index
#                         gallery_photos GET      /gallery-photos(.:format)                                     gallery#index
#                                   news GET      /news(.:format)                                               news#index
#                     newsletter_sign_up GET|POST /newsletter/sign-up(.:format)                                 newsletter#sign_up
#                              franchise GET      /franchise(.:format)                                          redirect(301, https://pages.solasalonstudios.com/signup?utm_campaign=entrepreneur_print_ad&utm_source=referral&utm_medium=website)
#                                covid19 GET      /covid19(.:format)                                            redirect(301, https://solasalonstudios-covid19.com/)
#                              amenities GET      /amenities(.:format)                                          own_your_salon#index
#                         own_your_salon GET      /own-your-salon(.:format)                                     own_your_salon#index
#                                        GET      /own-your-salon/:tab(.:format)                                own_your_salon#index
#                                    own GET      /own(.:format)                                                own_your_salon#index
#                   own_studio_amenities GET      /own/studio-amenities(.:format)                               own_your_salon#studio_amenities
#                     own_own_your_salon GET      /own/own-your-salon(.:format)                                 own_your_salon#own_your_salon
#                           own_sola_pro GET      /own/sola-pro(.:format)                                       own_your_salon#old_sola_pro
#                      own_sola_sessions GET      /own/sola-sessions(.:format)                                  own_your_salon#old_sola_sessions
#                         own_solagenius GET      /own/solagenius(.:format)                                     own_your_salon#old_solagenius
#                                own_tab GET      /own/:tab(.:format)                                           own_your_salon#index
#                            our_studios GET      /our-studios(.:format)                                        own_your_salon#our_studios
#                               sola_pro GET      /sola-pro(.:format)                                           own_your_salon#sola_pro
#                          sola_sessions GET      /sola-sessions(.:format)                                      own_your_salon#sola_sessions
#                             solagenius GET      /solagenius(.:format)                                         own_your_salon#solagenius
#                               why_sola GET      /why-sola(.:format)                                           own_your_salon#why_sola
#          why_sola_contact_form_success GET      /why-sola/contact-form-success(.:format)                      own_your_salon#contact_form_success
#                         privacy_policy GET      /privacy-policy(.:format)                                     legal#privacy_policy
#                accessibility_statement GET      /accessibility-statement(.:format)                            legal#accessibility_statement
#               request_franchising_info GET      /request-franchising-info(.:format)                           contact_us#index
#                         request_a_tour GET      /tour/request-a-tour(.:format)                                contact_us#index
#                          rent_a_studio GET      /rent-a-studio(.:format)                                      contact_us#index
#                    franchising_request GET|POST /franchising-request(.:format)                                contact_us#franchising_request
#                         search_results GET|POST /search/results(.:format)                                     search#results
#                   booknow_landing_page GET|POST /solagenius/booknow(.:format)                                 booknow#landing_page
#                         booknow_search GET|POST /booknow(.:format)                                            booknow#search
#                        booknow_results GET|POST /booknow/results(.:format)                                    booknow#results
#                        cojilio_results GET      /booknow/cojilio_results(.:format)                            booknow#cojilio_results
#               booknow_booking_complete GET|POST /booknow/booking-complete(.:format)                           booknow#booking_complete
#                   save_booknow_booking POST     /booknow/save-booknow-booking(.:format)                       booknow#save_booking
#              contact_us_request_a_tour POST     /contact-us-request-a-tour(.:format)                          contact_us#request_a_tour
#                        partner_inquiry GET|POST /partner-inquiry(.:format)                                    contact_us#partner_inquiry
#                              locations GET      /locations(.:format)                                          locations#index
#                     locations_by_state GET      /states/:state(.:format)                                      locations#state
#                  locations_by_province GET      /provinces/:state(.:format)                                   locations#state
#                         salon_stylists GET      /locations/:url_name/salon-professionals(/:service)(.:format) locations#stylists
#                     old_salon_location GET      /locations/:state/:city/:url_name(.:format)                   locations#old_salon
#                                        GET      /locations/state/:state(.:format)                             locations#state
#                   locations_6th_avenue GET      /locations/6th-avenue(.:format)                               locations#sixthaveredirect
#                         salon_location GET      /locations/:url_name(.:format)                                locations#salon
#          location_contact_form_success GET      /locations/:url_name/contact-form-success(.:format)           locations#contact_form_success
#                    find_salon_location GET|POST /find-salon-location(.:format)                                locations#find_salon
#                          locations_usa GET|POST /locations-usa(.:format)                                      locations#usa
#                   locations_fullscreen GET      /locations-fullscreen(.:format)                               locations#fullscreen
#                                        GET      /stores/:url_name(.:format)                                   locations#salon_redirect
#                                        GET      /store/:url_name(.:format)                                    locations#salon_redirect
#                                my_sola GET|POST /mysola(.:format)                                             my_sola#index
#                     show_my_sola_image GET|POST /mysola/:id(.:format)                                         my_sola#show
#                      s3_presigned_post POST     /mysola-s3-presigned-post(.:format)                           my_sola#s3_presigned_post
#                  my_sola_image_preview GET|POST /mysola-image-preview/:id(.:format)                           my_sola#image_preview
#                   my_sola_image_upload GET|POST /mysola-image-upload(.:format)                                my_sola#image_upload
#                                sola10k GET|POST /sola10k(.:format)                                            sola10k#index
#                     show_sola10k_image GET|POST /sola10k/:id(.:format)                                        sola10k#show
#               sola10ks3_presigned_post POST     /sola10k-s3-presigned-post(.:format)                          sola10k#s3_presigned_post
#                  sola10k_image_preview GET|POST /sola10k-image-preview/:id(.:format)                          sola10k#image_preview
#                   sola10k_image_upload GET|POST /sola10k-image-upload(.:format)                               sola10k#image_upload
#                                stylist GET      /stylist(.:format)                                            stylists#index
#                                        GET      /stylists/:url_name(.:format)                                 stylists#redirect
#                                        GET      /stylist/:url_name(.:format)                                  stylists#redirect
#                                        GET      /stylist/:url_name/:url(.:format)                             stylists#redirect
#                    salon_professionals GET      /salon-professionals(.:format)                                stylists#index
#                    find_a_professional GET      /findaprofessional(.:format)                                  stylists#index
#                          stylistsearch GET      /stylistsearch(.:format)                                      stylists#index
#                show_salon_professional GET      /salon-professional/:url_name(.:format)                       stylists#show
#                      going_independent GET      /goingindependent(.:format)                                   stylists#going_independent
# going_independent_contact_form_success GET      /goingindependent/contact-form-success(.:format)              stylists#going_independent_contact_form_success
#      salon_professional_send_a_message GET|POST /salon-professional-send-a-message(.:format)                  stylists#send_a_message
#                        financial_guide GET      /financialguide(.:format)                                     stylists#financial_guide
#   financial_guide_contact_form_success GET      /financialguide/contact-form-success(.:format)                stylists#financial_guide_contact_form_success
#                           show_article GET      /article/:url_name(.:format)                                  article#show
#                                        GET      /readmore/:url_name(.:format)                                 article#show
#                                   blog GET      /blog(.:format)                                               blog#index
#                              show_blog GET      /blog/:url_name(.:format)                                     blog#show
#                                        GET      /blog/:url_name/contact-form-success(.:format)                blog#contact_form_success
#                      show_blog_preview GET      /blog-preview/:url_name(.:format)                             blog#show_preview
#                                        GET      /blog-readmore/:url_name(.:format)                            blog#show
#                          blog_category GET      /blog/category/:category_url_name(.:format)                   blog#index
#                                regions GET      /regions(.:format)                                            locations#index
#                                        GET      /region/:url_name(.:format)                                   locations#region
#                                 region GET      /regions/:url_name(.:format)                                  locations#region
#                 emails_welcome_to_sola GET      /emails/welcome-to-sola(.:format)                             emails#welcome_to_sola
#                   forgot_password_form GET|POST /forgot-password(.:format)                                    forgot_password#form
#                  forgot_password_reset GET|POST /forgot-password/reset(.:format)                              forgot_password#reset
#                               sessions GET|POST /sessions(.:format)                                           sessions#index
#                       portland_session GET|POST /sola-sessions/portland(.:format)                             sessions#portland
#                  api_sola_cms_articles GET      /api/articles(.:format)                                       api/sola_cms/articles#index
#                                        POST     /api/articles(.:format)                                       api/sola_cms/articles#create
#               new_api_sola_cms_article GET      /api/articles/new(.:format)                                   api/sola_cms/articles#new
#              edit_api_sola_cms_article GET      /api/articles/:id/edit(.:format)                              api/sola_cms/articles#edit
#                   api_sola_cms_article GET      /api/articles/:id(.:format)                                   api/sola_cms/articles#show
#                                        PATCH    /api/articles/:id(.:format)                                   api/sola_cms/articles#update
#                                        PUT      /api/articles/:id(.:format)                                   api/sola_cms/articles#update
#                                        DELETE   /api/articles/:id(.:format)                                   api/sola_cms/articles#destroy
#                     api_sola_cms_blogs GET      /api/blogs(.:format)                                          api/sola_cms/blogs#index
#                                        POST     /api/blogs(.:format)                                          api/sola_cms/blogs#create
#                  new_api_sola_cms_blog GET      /api/blogs/new(.:format)                                      api/sola_cms/blogs#new
#                 edit_api_sola_cms_blog GET      /api/blogs/:id/edit(.:format)                                 api/sola_cms/blogs#edit
#                      api_sola_cms_blog GET      /api/blogs/:id(.:format)                                      api/sola_cms/blogs#show
#                                        PATCH    /api/blogs/:id(.:format)                                      api/sola_cms/blogs#update
#                                        PUT      /api/blogs/:id(.:format)                                      api/sola_cms/blogs#update
#                                        DELETE   /api/blogs/:id(.:format)                                      api/sola_cms/blogs#destroy
#    api_sola_cms_request_tour_inquiries GET      /api/request_tour_inquiries(.:format)                         api/sola_cms/request_tour_inquiries#index
#                                        POST     /api/request_tour_inquiries(.:format)                         api/sola_cms/request_tour_inquiries#create
#  new_api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/new(.:format)                     api/sola_cms/request_tour_inquiries#new
# edit_api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/:id/edit(.:format)                api/sola_cms/request_tour_inquiries#edit
#      api_sola_cms_request_tour_inquiry GET      /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#show
#                                        PATCH    /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#update
#                                        PUT      /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#update
#                                        DELETE   /api/request_tour_inquiries/:id(.:format)                     api/sola_cms/request_tour_inquiries#destroy
#         api_sola_cms_book_now_bookings GET      /api/book_now_bookings(.:format)                              api/sola_cms/book_now_bookings#index
#                                        POST     /api/book_now_bookings(.:format)                              api/sola_cms/book_now_bookings#create
#      new_api_sola_cms_book_now_booking GET      /api/book_now_bookings/new(.:format)                          api/sola_cms/book_now_bookings#new
#     edit_api_sola_cms_book_now_booking GET      /api/book_now_bookings/:id/edit(.:format)                     api/sola_cms/book_now_bookings#edit
#          api_sola_cms_book_now_booking GET      /api/book_now_bookings/:id(.:format)                          api/sola_cms/book_now_bookings#show
#                                        PATCH    /api/book_now_bookings/:id(.:format)                          api/sola_cms/book_now_bookings#update
#                                        PUT      /api/book_now_bookings/:id(.:format)                          api/sola_cms/book_now_bookings#update
#                                        DELETE   /api/book_now_bookings/:id(.:format)                          api/sola_cms/book_now_bookings#destroy
#                 api_sola_cms_locations GET      /api/locations(.:format)                                      api/sola_cms/locations#index
#                                        POST     /api/locations(.:format)                                      api/sola_cms/locations#create
#              new_api_sola_cms_location GET      /api/locations/new(.:format)                                  api/sola_cms/locations#new
#             edit_api_sola_cms_location GET      /api/locations/:id/edit(.:format)                             api/sola_cms/locations#edit
#                  api_sola_cms_location GET      /api/locations/:id(.:format)                                  api/sola_cms/locations#show
#                                        PATCH    /api/locations/:id(.:format)                                  api/sola_cms/locations#update
#                                        PUT      /api/locations/:id(.:format)                                  api/sola_cms/locations#update
#                                        DELETE   /api/locations/:id(.:format)                                  api/sola_cms/locations#destroy
#         api_sola_cms_partner_inquiries GET      /api/partner_inquiries(.:format)                              api/sola_cms/partner_inquiries#index
#                                        POST     /api/partner_inquiries(.:format)                              api/sola_cms/partner_inquiries#create
#       new_api_sola_cms_partner_inquiry GET      /api/partner_inquiries/new(.:format)                          api/sola_cms/partner_inquiries#new
#      edit_api_sola_cms_partner_inquiry GET      /api/partner_inquiries/:id/edit(.:format)                     api/sola_cms/partner_inquiries#edit
#           api_sola_cms_partner_inquiry GET      /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#show
#                                        PATCH    /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#update
#                                        PUT      /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#update
#                                        DELETE   /api/partner_inquiries/:id(.:format)                          api/sola_cms/partner_inquiries#destroy
#                      api_sola_cms_msas GET      /api/msas(.:format)                                           api/sola_cms/msas#index
#                                        POST     /api/msas(.:format)                                           api/sola_cms/msas#create
#                   new_api_sola_cms_msa GET      /api/msas/new(.:format)                                       api/sola_cms/msas#new
#                  edit_api_sola_cms_msa GET      /api/msas/:id/edit(.:format)                                  api/sola_cms/msas#edit
#                       api_sola_cms_msa GET      /api/msas/:id(.:format)                                       api/sola_cms/msas#show
#                                        PATCH    /api/msas/:id(.:format)                                       api/sola_cms/msas#update
#                                        PUT      /api/msas/:id(.:format)                                       api/sola_cms/msas#update
#                                        DELETE   /api/msas/:id(.:format)                                       api/sola_cms/msas#destroy
#            api_sola_cms_my_sola_images GET      /api/my_sola_images(.:format)                                 api/sola_cms/my_sola_images#index
#                                        POST     /api/my_sola_images(.:format)                                 api/sola_cms/my_sola_images#create
#         new_api_sola_cms_my_sola_image GET      /api/my_sola_images/new(.:format)                             api/sola_cms/my_sola_images#new
#        edit_api_sola_cms_my_sola_image GET      /api/my_sola_images/:id/edit(.:format)                        api/sola_cms/my_sola_images#edit
#             api_sola_cms_my_sola_image GET      /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#show
#                                        PATCH    /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#update
#                                        PUT      /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#update
#                                        DELETE   /api/my_sola_images/:id(.:format)                             api/sola_cms/my_sola_images#destroy
#             api_sola_cms_state_regions GET      /api/state_regions(.:format)                                  api/sola_cms/state_regions#index
#                                        POST     /api/state_regions(.:format)                                  api/sola_cms/state_regions#create
#          new_api_sola_cms_state_region GET      /api/state_regions/new(.:format)                              api/sola_cms/state_regions#new
#         edit_api_sola_cms_state_region GET      /api/state_regions/:id/edit(.:format)                         api/sola_cms/state_regions#edit
#              api_sola_cms_state_region GET      /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#show
#                                        PATCH    /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#update
#                                        PUT      /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#update
#                                        DELETE   /api/state_regions/:id(.:format)                              api/sola_cms/state_regions#destroy
#           api_sola_cms_side_menu_items GET      /api/side_menu_items(.:format)                                api/sola_cms/side_menu_items#index
#                                        POST     /api/side_menu_items(.:format)                                api/sola_cms/side_menu_items#create
#        new_api_sola_cms_side_menu_item GET      /api/side_menu_items/new(.:format)                            api/sola_cms/side_menu_items#new
#       edit_api_sola_cms_side_menu_item GET      /api/side_menu_items/:id/edit(.:format)                       api/sola_cms/side_menu_items#edit
#            api_sola_cms_side_menu_item GET      /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#show
#                                        PATCH    /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#update
#                                        PUT      /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#update
#                                        DELETE   /api/side_menu_items/:id(.:format)                            api/sola_cms/side_menu_items#destroy
#            api_sola_cms_sola10k_images GET      /api/sola10k_images(.:format)                                 api/sola_cms/sola10k_images#index
#                                        POST     /api/sola10k_images(.:format)                                 api/sola_cms/sola10k_images#create
#         new_api_sola_cms_sola10k_image GET      /api/sola10k_images/new(.:format)                             api/sola_cms/sola10k_images#new
#        edit_api_sola_cms_sola10k_image GET      /api/sola10k_images/:id/edit(.:format)                        api/sola_cms/sola10k_images#edit
#             api_sola_cms_sola10k_image GET      /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#show
#                                        PATCH    /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#update
#                                        PUT      /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#update
#                                        DELETE   /api/sola10k_images/:id(.:format)                             api/sola_cms/sola10k_images#destroy
#          api_sola_cms_stylist_messages GET      /api/stylist_messages(.:format)                               api/sola_cms/stylist_messages#index
#                                        POST     /api/stylist_messages(.:format)                               api/sola_cms/stylist_messages#create
#       new_api_sola_cms_stylist_message GET      /api/stylist_messages/new(.:format)                           api/sola_cms/stylist_messages#new
#      edit_api_sola_cms_stylist_message GET      /api/stylist_messages/:id/edit(.:format)                      api/sola_cms/stylist_messages#edit
#           api_sola_cms_stylist_message GET      /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#show
#                                        PATCH    /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#update
#                                        PUT      /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#update
#                                        DELETE   /api/stylist_messages/:id(.:format)                           api/sola_cms/stylist_messages#destroy
#                    api_sola_cms_brands GET      /api/brands(.:format)                                         api/sola_cms/brands#index
#                                        POST     /api/brands(.:format)                                         api/sola_cms/brands#create
#                 new_api_sola_cms_brand GET      /api/brands/new(.:format)                                     api/sola_cms/brands#new
#                edit_api_sola_cms_brand GET      /api/brands/:id/edit(.:format)                                api/sola_cms/brands#edit
#                     api_sola_cms_brand GET      /api/brands/:id(.:format)                                     api/sola_cms/brands#show
#                                        PATCH    /api/brands/:id(.:format)                                     api/sola_cms/brands#update
#                                        PUT      /api/brands/:id(.:format)                                     api/sola_cms/brands#update
#                                        DELETE   /api/brands/:id(.:format)                                     api/sola_cms/brands#destroy
#     api_sola_cms_education_hero_images GET      /api/education_hero_images(.:format)                          api/sola_cms/education_hero_images#index
#                                        POST     /api/education_hero_images(.:format)                          api/sola_cms/education_hero_images#create
#  new_api_sola_cms_education_hero_image GET      /api/education_hero_images/new(.:format)                      api/sola_cms/education_hero_images#new
# edit_api_sola_cms_education_hero_image GET      /api/education_hero_images/:id/edit(.:format)                 api/sola_cms/education_hero_images#edit
#      api_sola_cms_education_hero_image GET      /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#show
#                                        PATCH    /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#update
#                                        PUT      /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#update
#                                        DELETE   /api/education_hero_images/:id(.:format)                      api/sola_cms/education_hero_images#destroy
#      api_sola_cms_product_informations GET      /api/product_informations(.:format)                           api/sola_cms/product_informations#index
#                                        POST     /api/product_informations(.:format)                           api/sola_cms/product_informations#create
#   new_api_sola_cms_product_information GET      /api/product_informations/new(.:format)                       api/sola_cms/product_informations#new
#  edit_api_sola_cms_product_information GET      /api/product_informations/:id/edit(.:format)                  api/sola_cms/product_informations#edit
#       api_sola_cms_product_information GET      /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#show
#                                        PATCH    /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#update
#                                        PUT      /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#update
#                                        DELETE   /api/product_informations/:id(.:format)                       api/sola_cms/product_informations#destroy
#                      api_sola_cms_tags GET      /api/tags(.:format)                                           api/sola_cms/tags#index
#                                        POST     /api/tags(.:format)                                           api/sola_cms/tags#create
#                   new_api_sola_cms_tag GET      /api/tags/new(.:format)                                       api/sola_cms/tags#new
#                  edit_api_sola_cms_tag GET      /api/tags/:id/edit(.:format)                                  api/sola_cms/tags#edit
#                       api_sola_cms_tag GET      /api/tags/:id(.:format)                                       api/sola_cms/tags#show
#                                        PATCH    /api/tags/:id(.:format)                                       api/sola_cms/tags#update
#                                        PUT      /api/tags/:id(.:format)                                       api/sola_cms/tags#update
#                                        DELETE   /api/tags/:id(.:format)                                       api/sola_cms/tags#destroy
#       api_sola_cms_tools_and_resources GET      /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#index
#                                        POST     /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#create
#    new_api_sola_cms_tools_and_resource GET      /api/tools_and_resources/new(.:format)                        api/sola_cms/tools_and_resources#new
#   edit_api_sola_cms_tools_and_resource GET      /api/tools_and_resources/:id/edit(.:format)                   api/sola_cms/tools_and_resources#edit
#        api_sola_cms_tools_and_resource GET      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#show
#                                        PATCH    /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                        PUT      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                        DELETE   /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#destroy
#              api_sola_cms_home_buttons GET      /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#index
#                                        POST     /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#create
#           new_api_sola_cms_home_button GET      /api/home_buttons/new(.:format)                               api/sola_cms/home_buttons#new
#          edit_api_sola_cms_home_button GET      /api/home_buttons/:id/edit(.:format)                          api/sola_cms/home_buttons#edit
#               api_sola_cms_home_button GET      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#show
#                                        PATCH    /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                        PUT      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                        DELETE   /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#destroy
#                    api_sola_cms_admins GET      /api/admins(.:format)                                         api/sola_cms/admins#index
#                                        POST     /api/admins(.:format)                                         api/sola_cms/admins#create
#                 new_api_sola_cms_admin GET      /api/admins/new(.:format)                                     api/sola_cms/admins#new
#                edit_api_sola_cms_admin GET      /api/admins/:id/edit(.:format)                                api/sola_cms/admins#edit
#                     api_sola_cms_admin GET      /api/admins/:id(.:format)                                     api/sola_cms/admins#show
#                                        PATCH    /api/admins/:id(.:format)                                     api/sola_cms/admins#update
#                                        PUT      /api/admins/:id(.:format)                                     api/sola_cms/admins#update
#                                        DELETE   /api/admins/:id(.:format)                                     api/sola_cms/admins#destroy
#                     api_sola_cms_deals GET      /api/deals(.:format)                                          api/sola_cms/deals#index
#                                        POST     /api/deals(.:format)                                          api/sola_cms/deals#create
#                  new_api_sola_cms_deal GET      /api/deals/new(.:format)                                      api/sola_cms/deals#new
#                 edit_api_sola_cms_deal GET      /api/deals/:id/edit(.:format)                                 api/sola_cms/deals#edit
#                      api_sola_cms_deal GET      /api/deals/:id(.:format)                                      api/sola_cms/deals#show
#                                        PATCH    /api/deals/:id(.:format)                                      api/sola_cms/deals#update
#                                        PUT      /api/deals/:id(.:format)                                      api/sola_cms/deals#update
#                                        DELETE   /api/deals/:id(.:format)                                      api/sola_cms/deals#destroy
#        api_sola_cms_events_and_classes GET      /api/events_and_classes(.:format)                             api/sola_cms/events_and_classes#index
#                                        POST     /api/events_and_classes(.:format)                             api/sola_cms/events_and_classes#create
#      new_api_sola_cms_events_and_class GET      /api/events_and_classes/new(.:format)                         api/sola_cms/events_and_classes#new
#     edit_api_sola_cms_events_and_class GET      /api/events_and_classes/:id/edit(.:format)                    api/sola_cms/events_and_classes#edit
#          api_sola_cms_events_and_class GET      /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#show
#                                        PATCH    /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#update
#                                        PUT      /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#update
#                                        DELETE   /api/events_and_classes/:id(.:format)                         api/sola_cms/events_and_classes#destroy
#                                        GET      /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#index
#                                        POST     /api/tools_and_resources(.:format)                            api/sola_cms/tools_and_resources#create
#                                        GET      /api/tools_and_resources/new(.:format)                        api/sola_cms/tools_and_resources#new
#                                        GET      /api/tools_and_resources/:id/edit(.:format)                   api/sola_cms/tools_and_resources#edit
#                                        GET      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#show
#                                        PATCH    /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                        PUT      /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#update
#                                        DELETE   /api/tools_and_resources/:id(.:format)                        api/sola_cms/tools_and_resources#destroy
#             api_sola_cms_notifications GET      /api/notifications(.:format)                                  api/sola_cms/notifications#index
#                                        POST     /api/notifications(.:format)                                  api/sola_cms/notifications#create
#          new_api_sola_cms_notification GET      /api/notifications/new(.:format)                              api/sola_cms/notifications#new
#         edit_api_sola_cms_notification GET      /api/notifications/:id/edit(.:format)                         api/sola_cms/notifications#edit
#              api_sola_cms_notification GET      /api/notifications/:id(.:format)                              api/sola_cms/notifications#show
#                                        PATCH    /api/notifications/:id(.:format)                              api/sola_cms/notifications#update
#                                        PUT      /api/notifications/:id(.:format)                              api/sola_cms/notifications#update
#                                        DELETE   /api/notifications/:id(.:format)                              api/sola_cms/notifications#destroy
#                                        GET      /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#index
#                                        POST     /api/home_buttons(.:format)                                   api/sola_cms/home_buttons#create
#                                        GET      /api/home_buttons/new(.:format)                               api/sola_cms/home_buttons#new
#                                        GET      /api/home_buttons/:id/edit(.:format)                          api/sola_cms/home_buttons#edit
#                                        GET      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#show
#                                        PATCH    /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                        PUT      /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#update
#                                        DELETE   /api/home_buttons/:id(.:format)                               api/sola_cms/home_buttons#destroy
#                api_sola_cms_categories GET      /api/categories(.:format)                                     api/sola_cms/categories#index
#                                        POST     /api/categories(.:format)                                     api/sola_cms/categories#create
#              new_api_sola_cms_category GET      /api/categories/new(.:format)                                 api/sola_cms/categories#new
#             edit_api_sola_cms_category GET      /api/categories/:id/edit(.:format)                            api/sola_cms/categories#edit
#                  api_sola_cms_category GET      /api/categories/:id(.:format)                                 api/sola_cms/categories#show
#                                        PATCH    /api/categories/:id(.:format)                                 api/sola_cms/categories#update
#                                        PUT      /api/categories/:id(.:format)                                 api/sola_cms/categories#update
#                                        DELETE   /api/categories/:id(.:format)                                 api/sola_cms/categories#destroy
#        api_sola_cms_rent_manager_units GET      /api/rent_manager_units(.:format)                             api/sola_cms/rent_manager_units#index
#                                        POST     /api/rent_manager_units(.:format)                             api/sola_cms/rent_manager_units#create
#     new_api_sola_cms_rent_manager_unit GET      /api/rent_manager_units/new(.:format)                         api/sola_cms/rent_manager_units#new
#    edit_api_sola_cms_rent_manager_unit GET      /api/rent_manager_units/:id/edit(.:format)                    api/sola_cms/rent_manager_units#edit
#         api_sola_cms_rent_manager_unit GET      /api/rent_manager_units/:id(.:format)                         api/sola_cms/rent_manager_units#show
#                                        PATCH    /api/rent_manager_units/:id(.:format)                         api/sola_cms/rent_manager_units#update
#                                        PUT      /api/rent_manager_units/:id(.:format)                         api/sola_cms/rent_manager_units#update
#                                        DELETE   /api/rent_manager_units/:id(.:format)                         api/sola_cms/rent_manager_units#destroy
#                    api_sola_cms_videos GET      /api/videos(.:format)                                         api/sola_cms/videos#index
#                                        POST     /api/videos(.:format)                                         api/sola_cms/videos#create
#                 new_api_sola_cms_video GET      /api/videos/new(.:format)                                     api/sola_cms/videos#new
#                edit_api_sola_cms_video GET      /api/videos/:id/edit(.:format)                                api/sola_cms/videos#edit
#                     api_sola_cms_video GET      /api/videos/:id(.:format)                                     api/sola_cms/videos#show
#                                        PATCH    /api/videos/:id(.:format)                                     api/sola_cms/videos#update
#                                        PUT      /api/videos/:id(.:format)                                     api/sola_cms/videos#update
#                                        DELETE   /api/videos/:id(.:format)                                     api/sola_cms/videos#destroy
#             api_sola_cms_stylist_units GET      /api/stylist_units(.:format)                                  api/sola_cms/stylist_units#index
#                                        POST     /api/stylist_units(.:format)                                  api/sola_cms/stylist_units#create
#          new_api_sola_cms_stylist_unit GET      /api/stylist_units/new(.:format)                              api/sola_cms/stylist_units#new
#         edit_api_sola_cms_stylist_unit GET      /api/stylist_units/:id/edit(.:format)                         api/sola_cms/stylist_units#edit
#              api_sola_cms_stylist_unit GET      /api/stylist_units/:id(.:format)                              api/sola_cms/stylist_units#show
#                                        PATCH    /api/stylist_units/:id(.:format)                              api/sola_cms/stylist_units#update
#                                        PUT      /api/stylist_units/:id(.:format)                              api/sola_cms/stylist_units#update
#                                        DELETE   /api/stylist_units/:id(.:format)                              api/sola_cms/stylist_units#destroy
#                 api_sola_cms_countries GET      /api/countries(.:format)                                      api/sola_cms/countries#index
#                                        POST     /api/countries(.:format)                                      api/sola_cms/countries#create
#               new_api_sola_cms_country GET      /api/countries/new(.:format)                                  api/sola_cms/countries#new
#              edit_api_sola_cms_country GET      /api/countries/:id/edit(.:format)                             api/sola_cms/countries#edit
#                   api_sola_cms_country GET      /api/countries/:id(.:format)                                  api/sola_cms/countries#show
#                                        PATCH    /api/countries/:id(.:format)                                  api/sola_cms/countries#update
#                                        PUT      /api/countries/:id(.:format)                                  api/sola_cms/countries#update
#                                        DELETE   /api/countries/:id(.:format)                                  api/sola_cms/countries#destroy
#     api_sola_cms_franchising_inquiries GET      /api/franchising_inquiries(.:format)                          api/sola_cms/franchising_inquiries#index
#                                        POST     /api/franchising_inquiries(.:format)                          api/sola_cms/franchising_inquiries#create
#   new_api_sola_cms_franchising_inquiry GET      /api/franchising_inquiries/new(.:format)                      api/sola_cms/franchising_inquiries#new
#  edit_api_sola_cms_franchising_inquiry GET      /api/franchising_inquiries/:id/edit(.:format)                 api/sola_cms/franchising_inquiries#edit
#       api_sola_cms_franchising_inquiry GET      /api/franchising_inquiries/:id(.:format)                      api/sola_cms/franchising_inquiries#show
#                                        PATCH    /api/franchising_inquiries/:id(.:format)                      api/sola_cms/franchising_inquiries#update
#                                        PUT      /api/franchising_inquiries/:id(.:format)                      api/sola_cms/franchising_inquiries#update
#                                        DELETE   /api/franchising_inquiries/:id(.:format)                      api/sola_cms/franchising_inquiries#destroy
#                       api_v1_locations GET|POST /api/v1/locations(.:format)                                   api/v1/locations#index
#                                 api_v1 GET|POST /api/v1/locations/:id(.:format)                               api/v1/locations#show
#                       api_v2_locations GET|POST /api/v2/locations(.:format)                                   api/v2/locations#index
#                                 api_v2 GET|POST /api/v2/locations/:id(.:format)                               api/v2/locations#show
#      get_location_data_api_v2_location GET      /api/v2/locations/:id/get_location_data(.:format)             api/v2/locations#get_location_data
#                                        GET      /api/v2/locations(.:format)                                   api/v2/locations#index
#                                        POST     /api/v2/locations(.:format)                                   api/v2/locations#create
#                    new_api_v2_location GET      /api/v2/locations/new(.:format)                               api/v2/locations#new
#                   edit_api_v2_location GET      /api/v2/locations/:id/edit(.:format)                          api/v2/locations#edit
#                        api_v2_location GET      /api/v2/locations/:id(.:format)                               api/v2/locations#show
#                                        PATCH    /api/v2/locations/:id(.:format)                               api/v2/locations#update
#                                        PUT      /api/v2/locations/:id(.:format)                               api/v2/locations#update
#                                        DELETE   /api/v2/locations/:id(.:format)                               api/v2/locations#destroy
#                api_v3_hubspot_webhooks POST     /api/v3/hubspot_webhooks(.:format)                            api/v3/hubspot_webhooks#create
#           api_v3_rent_manager_webhooks POST     /api/v3/rent_manager_webhooks(.:format)                       api/v3/rent_manager_webhooks#create
#                         cms_save_lease GET|POST /cms/save-lease(.:format)                                     cms#save_lease
#                       cms_save_stylist GET|POST /cms/save-stylist(.:format)                                   cms#save_stylist
#                   cms_locations_select GET|POST /cms/locations-select(.:format)                               cms#locations_select
#                     cms_studios_select GET|POST /cms/studios-select(.:format)                                 cms#studios_select
#                    cms_stylists_select GET|POST /cms/stylists-select(.:format)                                cms#stylists_select
#                  cms_s3_presigned_post GET|POST /cms/s3-presigned-post(.:format)                              cms#s3_presigned_post
#                               sejasola GET|POST /sejasola(.:format)                                           brazil#sejasola
#                                        GET      /:url_name(.:format)                                          redirect#short
#                         sendgrid_event POST     /sendgrid/event(.:format)                                     gridhook/events#create
#
# Routes for RailsAdmin::Engine:
#     dashboard GET         /                                    rails_admin/main#dashboard
#         index GET|POST    /:model_name(.:format)               rails_admin/main#index
#           new GET|POST    /:model_name/new(.:format)           rails_admin/main#new
#        export GET|POST    /:model_name/export(.:format)        rails_admin/main#export
#   bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)   rails_admin/main#bulk_delete
# custom_export GET|POST    /:model_name/custom_export(.:format) rails_admin/main#custom_export
#   bulk_action POST        /:model_name/bulk_action(.:format)   rails_admin/main#bulk_action
#          show GET         /:model_name/:id(.:format)           rails_admin/main#show
#          edit GET|PUT     /:model_name/:id/edit(.:format)      rails_admin/main#edit
#        delete GET|DELETE  /:model_name/:id/delete(.:format)    rails_admin/main#delete
#
# Routes for Franchising::Engine:
#                   root GET  /                                        franchising/website#index
#         privacy_policy GET  /privacy-policy(.:format)                franchising/website#privacy_policy
#                    ada GET  /ada(.:format)                           franchising/website#ada
#              thank_you GET  /thank-you(.:format)                     franchising/website#thank_you
#             learn_more GET  /learn-more(.:format)                    franchising/website#learn_more
#              our_story GET  /our-story(.:format)                     franchising/website#our_story
#               why_sola GET  /why-sola(.:format)                      franchising/website#why_sola
#            in_the_news GET  /in-the-news(.:format)                   franchising/website#in_the_news
# franchising_form_index POST /franchising_form(.:format)              franchising/franchising_form#create
#     franchise_articles GET  /franchise_articles(.:format)            franchising/franchise_articles#index
#      franchise_article GET  /franchise_articles/:id(.:format)        franchising/franchise_articles#show
#                        GET  /pdfs/Sola_Franchise_Guide.pdf(.:format) franchising/files#pdf_guide
#
# Routes for Pro::Engine:
#                                        root GET      /                                                      pro/splash#index
#                                             GET|POST /r/:public_id(.:format)                                pro/redirect#short_link
#                             forgot_password GET|POST /forgot-password(.:format)                             pro/password#forgot
#                              reset_password GET|POST /reset-password/:id(.:format)                          pro/password#reset
#                              api_v1_classes GET|POST /api/v1/classes(.:format)                              pro/api/v1/classes#index {:format=>:json}
#                                      api_v1 GET|POST /api/v1/classes_load_more/:id(.:format)                pro/api/v1/classes#load_more {:format=>:json}
#                            api_v1_get_class GET|POST /api/v1/get_class(.:format)                            pro/api/v1/classes#get {:format=>:json}
#                                api_v1_deals GET|POST /api/v1/deals(.:format)                                pro/api/v1/deals#index {:format=>:json}
#                      api_v1_deals_load_more GET|POST /api/v1/deals_load_more(.:format)                      pro/api/v1/deals#load_more {:format=>:json}
#                             api_v1_get_deal GET|POST /api/v1/get_deal(.:format)                             pro/api/v1/deals#get {:format=>:json}
#                                api_v1_tools GET|POST /api/v1/tools(.:format)                                pro/api/v1/tools#index {:format=>:json}
#                      api_v1_tools_load_more GET|POST /api/v1/tools_load_more(.:format)                      pro/api/v1/tools#load_more {:format=>:json}
#                               api_v1_videos GET|POST /api/v1/videos(.:format)                               pro/api/v1/videos#index {:format=>:json}
#                     api_v1_videos_load_more GET|POST /api/v1/videos_load_more(.:format)                     pro/api/v1/videos#load_more {:format=>:json}
#                        api_v1_videos_search GET|POST /api/v1/videos_search(.:format)                        pro/api/v1/videos#search {:format=>:json}
#                   api_v1_videos_recommended GET|POST /api/v1/videos_recommended(.:format)                   pro/api/v1/videos#recommended {:format=>:json}
#                      api_v1_videos_log_view GET|POST /api/v1/videos_log_view(.:format)                      pro/api/v1/videos#log_view {:format=>:json}
#                   api_v1_videos_watch_later GET|POST /api/v1/videos_watch_later(.:format)                   pro/api/v1/videos#watch_later {:format=>:json}
#              api_v1_video_history_load_more GET|POST /api/v1/video_history_load_more(.:format)              pro/api/v1/videos#history_load_more {:format=>:json}
#          api_v1_video_watch_later_load_more GET|POST /api/v1/video_watch_later_load_more(.:format)          pro/api/v1/videos#watch_later_load_more {:format=>:json}
#                            api_v1_get_video GET|POST /api/v1/get_video(.:format)                            pro/api/v1/videos#get {:format=>:json}
#                               api_v1_brands GET|POST /api/v1/brands(.:format)                               pro/api/v1/brands#index {:format=>:json}
#                                             GET|POST /api/v1/brands/:id(.:format)                           pro/api/v1/brands#show {:format=>:json}
#                            api_v1_get_brand GET|POST /api/v1/get_brand(.:format)                            pro/api/v1/brands#get {:format=>:json}
#                                api_v1_blogs GET|POST /api/v1/blogs(.:format)                                pro/api/v1/blogs#index {:format=>:json}
#                      api_v1_blogs_load_more GET|POST /api/v1/blogs_load_more(.:format)                      pro/api/v1/blogs#load_more {:format=>:json}
#                         api_v1_blogs_search GET|POST /api/v1/blogs_search(.:format)                         pro/api/v1/blogs#search {:format=>:json}
#                           api_v1_users_find GET|POST /api/v1/users/find(.:format)                           pro/api/v1/users#find {:format=>:json}
#                       api_v1_users_page_url GET|POST /api/v1/users/page_url(.:format)                       pro/api/v1/users#page_url {:format=>:json}
#                   api_v1_users_active_check GET|POST /api/v1/users/active_check(.:format)                   pro/api/v1/users#active_check {:format=>:json}
#               api_v1_users_platform_version GET|POST /api/v1/users/platform_version(.:format)               pro/api/v1/users#platform_version {:format=>:json}
#                         api_v1_load_content GET|POST /api/v1/content/load(.:format)                         pro/api/v1/content#load {:format=>:json}
#                        api_v1_sessions_user GET|POST /api/v1/sessions/user(.:format)                        pro/api/v1/sessions#user {:format=>:json}
#                     api_v1_sessions_content GET|POST /api/v1/sessions/content(.:format)                     pro/api/v1/sessions#content {:format=>:json}
#                     api_v1_sessions_sign_in GET|POST /api/v1/sessions/sign_in(.:format)                     pro/api/v1/sessions#sign_in {:format=>:json}
#                     api_v1_sessions_sign_up GET|POST /api/v1/sessions/sign_up(.:format)                     pro/api/v1/sessions#sign_up {:format=>:json}
#             api_v1_sessions_forgot_password GET|POST /api/v1/sessions/forgot_password(.:format)             pro/api/v1/sessions#forgot_password {:format=>:json}
#              api_v1_sessions_reset_password GET|POST /api/v1/sessions/reset_password(.:format)              pro/api/v1/sessions#reset_password {:format=>:json}
#                                             GET|POST /api/v1/short_links/:public_id(.:format)               pro/api/v1/short_links#get {:format=>:json}
#                  api_v1_notifications_token GET|POST /api/v1/notifications/token(.:format)                  pro/api/v1/notifications#token {:format=>:json}
#                api_v1_notifications_dismiss GET|POST /api/v1/notifications/dismiss(.:format)                pro/api/v1/notifications#dismiss {:format=>:json}
#               api_v1_update_my_sola_website GET|POST /api/v1/update_my_sola_website(.:format)               pro/api/v1/update_my_sola_website#submit {:format=>:json}
#                              api_v2_classes GET|POST /api/v2/classes(.:format)                              pro/api/v2/classes#index {:format=>:json}
#                                      api_v2 GET|POST /api/v2/classes_load_more/:id(.:format)                pro/api/v2/classes#load_more {:format=>:json}
#                            api_v2_get_class GET|POST /api/v2/get_class(.:format)                            pro/api/v2/classes#get {:format=>:json}
#                                api_v2_deals GET|POST /api/v2/deals(.:format)                                pro/api/v2/deals#index {:format=>:json}
#                      api_v2_deals_load_more GET|POST /api/v2/deals_load_more(.:format)                      pro/api/v2/deals#load_more {:format=>:json}
#                             api_v2_get_deal GET|POST /api/v2/get_deal(.:format)                             pro/api/v2/deals#get {:format=>:json}
#              api_v2_leases_studio_agreement GET|POST /api/v2/leases/studio-agreement(.:format)              pro/api/v2/leases#studio_agreement {:format=>:json}
# api_v2_leases_save_lease_agreement_file_url GET|POST /api/v2/leases/save_lease_agreement_file_url(.:format) pro/api/v2/leases#save_lease_agreement_file_url {:format=>:json}
#                                api_v2_tools GET|POST /api/v2/tools(.:format)                                pro/api/v2/tools#index {:format=>:json}
#                      api_v2_tools_load_more GET|POST /api/v2/tools_load_more(.:format)                      pro/api/v2/tools#load_more {:format=>:json}
#                               api_v2_videos GET|POST /api/v2/videos(.:format)                               pro/api/v2/videos#index {:format=>:json}
#                     api_v2_videos_load_more GET|POST /api/v2/videos_load_more(.:format)                     pro/api/v2/videos#load_more {:format=>:json}
#                        api_v2_videos_search GET|POST /api/v2/videos_search(.:format)                        pro/api/v2/videos#search {:format=>:json}
#                   api_v2_videos_recommended GET|POST /api/v2/videos_recommended(.:format)                   pro/api/v2/videos#recommended {:format=>:json}
#                      api_v2_videos_log_view GET|POST /api/v2/videos_log_view(.:format)                      pro/api/v2/videos#log_view {:format=>:json}
#                   api_v2_videos_watch_later GET|POST /api/v2/videos_watch_later(.:format)                   pro/api/v2/videos#watch_later {:format=>:json}
#              api_v2_video_history_load_more GET|POST /api/v2/video_history_load_more(.:format)              pro/api/v2/videos#history_load_more {:format=>:json}
#          api_v2_video_watch_later_load_more GET|POST /api/v2/video_watch_later_load_more(.:format)          pro/api/v2/videos#watch_later_load_more {:format=>:json}
#                            api_v2_get_video GET|POST /api/v2/get_video(.:format)                            pro/api/v2/videos#get {:format=>:json}
#                               api_v2_brands GET|POST /api/v2/brands(.:format)                               pro/api/v2/brands#index {:format=>:json}
#                                             GET|POST /api/v2/brands/:id(.:format)                           pro/api/v2/brands#show {:format=>:json}
#                            api_v2_get_brand GET|POST /api/v2/get_brand(.:format)                            pro/api/v2/brands#get {:format=>:json}
#                                api_v2_blogs GET|POST /api/v2/blogs(.:format)                                pro/api/v2/blogs#index {:format=>:json}
#                      api_v2_blogs_load_more GET|POST /api/v2/blogs_load_more(.:format)                      pro/api/v2/blogs#load_more {:format=>:json}
#                         api_v2_blogs_search GET|POST /api/v2/blogs_search(.:format)                         pro/api/v2/blogs#search {:format=>:json}
#                           api_v2_users_find GET|POST /api/v2/users/find(.:format)                           pro/api/v2/users#find {:format=>:json}
#                       api_v2_users_page_url GET|POST /api/v2/users/page_url(.:format)                       pro/api/v2/users#page_url {:format=>:json}
#                   api_v2_users_active_check GET|POST /api/v2/users/active_check(.:format)                   pro/api/v2/users#active_check {:format=>:json}
#               api_v2_users_platform_version GET|POST /api/v2/users/platform_version(.:format)               pro/api/v2/users#platform_version {:format=>:json}
#                           api_v2_save_event GET|POST /api/v2/save-event(.:format)                           pro/api/v2/events#save {:format=>:json}
#                         api_v2_load_content GET|POST /api/v2/content/load(.:format)                         pro/api/v2/content#load {:format=>:json}
#                        api_v2_sessions_user GET|POST /api/v2/sessions/user(.:format)                        pro/api/v2/sessions#user {:format=>:json}
#                     api_v2_sessions_content GET|POST /api/v2/sessions/content(.:format)                     pro/api/v2/sessions#content {:format=>:json}
#                     api_v2_sessions_sign_in GET|POST /api/v2/sessions/sign_in(.:format)                     pro/api/v2/sessions#sign_in {:format=>:json}
#                     api_v2_sessions_sign_up GET|POST /api/v2/sessions/sign_up(.:format)                     pro/api/v2/sessions#sign_up {:format=>:json}
#             api_v2_sessions_forgot_password GET|POST /api/v2/sessions/forgot_password(.:format)             pro/api/v2/sessions#forgot_password {:format=>:json}
#              api_v2_sessions_reset_password GET|POST /api/v2/sessions/reset_password(.:format)              pro/api/v2/sessions#reset_password {:format=>:json}
#             api_v2_sessions_change_password POST     /api/v2/sessions/change_password(.:format)             pro/api/v2/sessions#change_password {:format=>:json}
#                                             GET|POST /api/v2/short_links/:public_id(.:format)               pro/api/v2/short_links#get {:format=>:json}
#                  api_v2_notifications_token GET|POST /api/v2/notifications/token(.:format)                  pro/api/v2/notifications#token {:format=>:json}
#                api_v2_notifications_dismiss GET|POST /api/v2/notifications/dismiss(.:format)                pro/api/v2/notifications#dismiss {:format=>:json}
#               api_v2_update_my_sola_website GET|POST /api/v2/update_my_sola_website(.:format)               pro/api/v2/update_my_sola_website#submit {:format=>:json}
#       api_v2_update_my_sola_website_walkins GET|POST /api/v2/update_my_sola_website/walkins(.:format)       pro/api/v2/update_my_sola_website#walkins {:format=>:json}
#                                api_v3_blogs GET      /api/v3/blogs(.:format)                                pro/api/v3/blogs#index {:format=>:json}
#                                 api_v3_blog GET      /api/v3/blogs/:id(.:format)                            pro/api/v3/blogs#show {:format=>:json}
#                               api_v3_brands GET      /api/v3/brands(.:format)                               pro/api/v3/brands#index {:format=>:json}
#                                api_v3_brand GET      /api/v3/brands/:id(.:format)                           pro/api/v3/brands#show {:format=>:json}
#                           api_v3_categories GET      /api/v3/categories(.:format)                           pro/api/v3/categories#index {:format=>:json}
#                                api_v3_deals GET      /api/v3/deals(.:format)                                pro/api/v3/deals#index {:format=>:json}
#                                 api_v3_deal GET      /api/v3/deals/:id(.:format)                            pro/api/v3/deals#show {:format=>:json}
#                              api_v3_devices GET      /api/v3/devices(.:format)                              pro/api/v3/devices#index {:format=>:json}
#                                             POST     /api/v3/devices(.:format)                              pro/api/v3/devices#create {:format=>:json}
#                               api_v3_device GET      /api/v3/devices/:token(.:format)                       pro/api/v3/devices#show {:format=>:json}
#                                             PATCH    /api/v3/devices/:token(.:format)                       pro/api/v3/devices#update {:format=>:json}
#                                             PUT      /api/v3/devices/:token(.:format)                       pro/api/v3/devices#update {:format=>:json}
#                               api_v3_events POST     /api/v3/events(.:format)                               pro/api/v3/events#create {:format=>:json}
#                        api_v3_notifications GET      /api/v3/notifications(.:format)                        pro/api/v3/notifications#index {:format=>:json}
#                                             POST     /api/v3/notifications(.:format)                        pro/api/v3/notifications#create {:format=>:json}
#                         api_v3_notification DELETE   /api/v3/notifications/:id(.:format)                    pro/api/v3/notifications#destroy {:format=>:json}
#                         api_v3_registration POST     /api/v3/registration(.:format)                         pro/api/v3/registrations#create {:format=>:json}
#                      api_v3_reset_passwords POST     /api/v3/reset_passwords(.:format)                      pro/api/v3/reset_passwords#create {:format=>:json}
#                       api_v3_reset_password PATCH    /api/v3/reset_passwords/:id(.:format)                  pro/api/v3/reset_passwords#update {:format=>:json}
#                                             PUT      /api/v3/reset_passwords/:id(.:format)                  pro/api/v3/reset_passwords#update {:format=>:json}
#                          api_v3_saved_items GET      /api/v3/saved_items(.:format)                          pro/api/v3/saved_items#index {:format=>:json}
#                                             POST     /api/v3/saved_items(.:format)                          pro/api/v3/saved_items#create {:format=>:json}
#                           api_v3_saved_item GET      /api/v3/saved_items/:id(.:format)                      pro/api/v3/saved_items#show {:format=>:json}
#                       api_v3_saved_searches GET      /api/v3/saved_searches(.:format)                       pro/api/v3/saved_searches#index {:format=>:json}
#                                             POST     /api/v3/saved_searches(.:format)                       pro/api/v3/saved_searches#create {:format=>:json}
#                         api_v3_search_index GET      /api/v3/search(.:format)                               pro/api/v3/search#index {:format=>:json}
#                              api_v3_session POST     /api/v3/session(.:format)                              pro/api/v3/sessions#create {:format=>:json}
#                         api_v3_sola_classes GET      /api/v3/sola_classes(.:format)                         pro/api/v3/sola_classes#index {:format=>:json}
#                           api_v3_sola_class GET      /api/v3/sola_classes/:id(.:format)                     pro/api/v3/sola_classes#show {:format=>:json}
#                                api_v3_tools GET      /api/v3/tools(.:format)                                pro/api/v3/tools#index {:format=>:json}
#                                 api_v3_tool GET      /api/v3/tools/:id(.:format)                            pro/api/v3/tools#show {:format=>:json}
#                   has_password_api_v3_users GET      /api/v3/users/has_password(.:format)                   pro/api/v3/users#has_password {:format=>:json}
#                        current_api_v3_users GET      /api/v3/users/current(.:format)                        pro/api/v3/users#current {:format=>:json}
#                    shopify_url_api_v3_users GET      /api/v3/users/shopify_url(.:format)                    pro/api/v3/users#shopify_url {:format=>:json}
#                                 api_v3_user PATCH    /api/v3/users/:id(.:format)                            pro/api/v3/users#update {:format=>:json}
#                                             PUT      /api/v3/users/:id(.:format)                            pro/api/v3/users#update {:format=>:json}
#                               api_v3_videos GET      /api/v3/videos(.:format)                               pro/api/v3/videos#index {:format=>:json}
#                                api_v3_video GET      /api/v3/videos/:id(.:format)                           pro/api/v3/videos#show {:format=>:json}
#                             api_v3_webinars GET      /api/v3/webinars(.:format)                             pro/api/v3/webinars#index {:format=>:json}
#                              api_v3_webinar GET      /api/v3/webinars/:id(.:format)                         pro/api/v3/webinars#show {:format=>:json}
#                api_v3_education_hero_images GET      /api/v3/education_hero_images(.:format)                pro/api/v3/education_hero_images#index {:format=>:json}
#       walkins_api_v3_update_my_sola_website POST     /api/v3/update_my_sola_website/walkins(.:format)       pro/api/v3/update_my_sola_websites#walkins {:format=>:json}
#               api_v3_update_my_sola_website POST     /api/v3/update_my_sola_website(.:format)               pro/api/v3/update_my_sola_websites#create {:format=>:json}
#                        current_api_v4_users GET      /api/v4/users/current(.:format)                        pro/api/v4/users#current {:format=>:json}
#       walkins_api_v4_update_my_sola_website POST     /api/v4/update_my_sola_website/walkins(.:format)       pro/api/v4/update_my_sola_websites#walkins {:format=>:json}
#               api_v4_update_my_sola_website POST     /api/v4/update_my_sola_website(.:format)               pro/api/v4/update_my_sola_websites#create {:format=>:json}
