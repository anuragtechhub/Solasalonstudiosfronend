Solasalonstudios::Application.routes.draw do
  require 'sidekiq/web'

  devise_for :admins

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

	# engines
  mount Franchising::Engine => '/', as: 'franchising_engine', constraints: DomainConstraint.new(ENV['FRANCHISING_DOMAINS'])
  mount Pro::Engine => '/', as: 'pro_engine', constraints: DomainConstraint.new(ENV['PRO_DOMAINS'])

	mount Ckeditor::Engine => '/ckeditor'

  get "/" => 'home#index', :as => :home
  get 'new-cms' => 'home#new_cms'
  root 'home#index'

  get 'robots.txt' => 'home#robots'
  get 'google575b4ff16cfb013a.html' => 'home#google_verification'
  get 'BingSiteAuth.xml' => 'home#bing_verification'
  get 'sitemap.xml' => 'home#sitemap'

  #get '5000' => 'home#sola_5000', :as => :sola_5000
  get 'franchising' => 'home#franchising', as: :franchising


  # About Us URLs

  get "about-us" => 'about_us#index', :as => :about_us
  get "about" => 'about_us#index'

  get "who-we-are" => 'about_us#who_we_are', :as => :who_we_are
  get "leadership" => 'about_us#leadership', :as => :leadership
  get "our-story" => 'about_us#our_story', :as => :our_story
  # get 'leadership/r-randall-clark' => 'about_us#randall_clark', :as => :randall_clark
  get 'leadership/rodrigo-miranda' => 'about_us#rodrigo_miranda', :as => :rodrigo_miranda
  # get 'leadership/ben-jones' => 'about_us#ben_jones', :as => :ben_jones
  # get 'leadership/jennie-wolff' => 'about_us#jennie_wolff', :as => :jennie_wolff
  # get 'leadership/myrle-mcneal' => 'about_us#myrle_mcneal', :as => :myrle_mcneal
  # get 'leadership/j-todd-neel' => 'about_us#todd_neel', :as => :todd_neel


  get "contact-us" => "contact_us#index", :as => :contact_us
  get "contact-us/contact-form-success" => 'contact_us#contact_form_success', :as => :contact_us_contact_form_success
  get "contact-us-thank-you" => 'contact_us#thank_you', :as => :contact_us_thank_you
  get 'contact_us' => "contact_us#index"

  get "diversity" => 'diversity#index' , :as => :diversity

  get "faq" => 'faq#index', :as => :faqs
  get "testimonials" => 'testimonials#index', :as => :testimonials

  get 'gallery' => 'gallery#index', :as => :gallery
  get 'gallery-photos' => 'gallery#index'

  get 'news' => 'news#index', :as => :news
  match "newsletter/sign-up" => 'newsletter#sign_up', :via => [:get, :post], :as => :newsletter_sign_up

  get 'franchise', to: redirect('https://pages.solasalonstudios.com/signup?utm_campaign=entrepreneur_print_ad&utm_source=referral&utm_medium=website', status: 301)

  get 'covid19', to: redirect('https://solasalonstudios-covid19.com/', status: 301), :as => :covid19

  # Own Your Salon URLs

  # old own paths
  get 'amenities' => 'own_your_salon#index'
  get "own-your-salon" => 'own_your_salon#index', :as => :own_your_salon
  get "own-your-salon/:tab" => 'own_your_salon#index'
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

  get "request-franchising-info" => "contact_us#index", :as => :request_franchising_info
  get "tour/request-a-tour" => 'contact_us#index', :as => :request_a_tour
  get "rent-a-studio" => 'contact_us#index', :as => :rent_a_studio
  match "franchising-request" => 'contact_us#franchising_request', :via => [:get, :post], :as => :franchising_request

  match "search/results" => 'search#results', :via => [:get, :post], :as => :search_results

  match 'solagenius/booknow' => 'booknow#landing_page', :via => [:get, :post], :as => :booknow_landing_page
  match 'booknow' => 'booknow#search', :via => [:get, :post], :as => :booknow_search
  match 'booknow/results(.:format)' => 'booknow#results', :via => [:get, :post], :as => :booknow_results
  match 'booknow/cojilio_results' => 'booknow#cojilio_results', :via => [:get], :as => :cojilio_results
  match 'booknow/booking-complete' => 'booknow#booking_complete', :via => [:get, :post], :as => :booknow_booking_complete
  match 'booknow/save-booknow-booking' => 'booknow#save_booking', :via => [:post], :as => :save_booknow_booking

  match 'contact-us-request-a-tour' => 'contact_us#request_a_tour', :via => [:post], :as => :contact_us_request_a_tour
  match 'partner-inquiry' => 'contact_us#partner_inquiry', :via => [:get, :post], :as => :partner_inquiry

  get "locations" => 'locations#index', :as => :locations
  get "states/:state" => 'locations#state', :as => :locations_by_state
  get "provinces/:state" => 'locations#state', :as => :locations_by_province
  #get "locations/:state/:city" => 'locations#city', :as => :locations_by_city

  get "locations/:url_name/salon-professionals(/:service)" => 'locations#stylists', :as => :salon_stylists
  get "locations/:state/:city/:url_name" => 'locations#old_salon', :as => :old_salon_location
  get "locations/state/:state" => 'locations#state'

  # custom location redirects
  get '/locations/6th-avenue' => 'locations#sixthaveredirect', :via => [:get, :post]

  get "locations/:url_name" => 'locations#salon', :as => :salon_location
  get "locations/:url_name/contact-form-success" => 'locations#contact_form_success', :as => :location_contact_form_success
  match 'find-salon-location' => 'locations#find_salon', :via => [:get, :post], :as => :find_salon_location
  match 'locations-usa' => 'locations#usa', :via => [:get, :post], :as => :locations_usa

  get "locations-fullscreen" => 'locations#fullscreen', :as => :locations_fullscreen
  get "stores/:url_name" => 'locations#salon_redirect'
  get "store/:url_name" => 'locations#salon_redirect'

  match 'mysola' => 'my_sola#index', :via => [:get, :post], :as => :my_sola
  match 'mysola/:id' => 'my_sola#show', :via => [:get, :post], :as => :show_my_sola_image
  match 'mysola-s3-presigned-post' => 'my_sola#s3_presigned_post', :via => [:post], :as => :s3_presigned_post
  match 'mysola-image-preview/:id' => 'my_sola#image_preview', :via => [:get, :post], :as => :my_sola_image_preview
  match 'mysola-image-upload' => 'my_sola#image_upload', :via => [:get, :post], :as => :my_sola_image_upload

  match 'sola10k' => 'sola10k#index', :via => [:get, :post], :as => :sola10k
  match 'sola10k/:id' => 'sola10k#show', :via => [:get, :post], :as => :show_sola10k_image
  match 'sola10k-s3-presigned-post' => 'sola10k#s3_presigned_post', :via => [:post], :as => :sola10ks3_presigned_post
  match 'sola10k-image-preview/:id' => 'sola10k#image_preview', :via => [:get, :post], :as => :sola10k_image_preview
  match 'sola10k-image-upload' => 'sola10k#image_upload', :via => [:get, :post], :as => :sola10k_image_upload

  get 'stylist' => 'stylists#index'
  get 'stylists/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name' => 'stylists#redirect'
  get 'stylist/:url_name/:url' => 'stylists#redirect'
  get 'salon-professionals' => 'stylists#index', :as => :salon_professionals
  get 'findaprofessional' => 'stylists#index', :as => :find_a_professional
  get 'stylistsearch' => 'stylists#index'
  get 'salon-professional/:url_name' => 'stylists#show', :as => :show_salon_professional
  get 'goingindependent' => 'stylists#going_independent', :as => :going_independent
  get "goingindependent/contact-form-success" => 'stylists#going_independent_contact_form_success', :as => :going_independent_contact_form_success
  match 'salon-professional-send-a-message' => 'stylists#send_a_message', :via => [:get, :post], :as => :salon_professional_send_a_message

  get 'financialguide' => 'stylists#financial_guide', :as => :financial_guide
  get "financialguide/contact-form-success" => 'stylists#financial_guide_contact_form_success', :as => :financial_guide_contact_form_success

  get "article/:url_name" => 'article#show', :as => :show_article
  get "readmore/:url_name" => 'article#show'

  get "blog" => 'blog#index', :as => :blog
  get "blog/:url_name" => 'blog#show', :as => :show_blog
  get "blog/:url_name/contact-form-success" => 'blog#contact_form_success'
  get "blog-preview/:url_name" => 'blog#show_preview', :as => :show_blog_preview
  get "blog-readmore/:url_name" => 'blog#show'
  get "blog/category/:category_url_name" => 'blog#index', :as => :blog_category

  # get 'digital-directory/:location_url_name' => 'digital_directory#show', :via => [:get, :post], :as => :digital_directory
  # get 'dd' => 'digital_directory#dd', :via => [:get, :post]
  # get 'dd/color' => 'digital_directory#color', :via => [:get, :post]

  get 'regions' => 'locations#index'
  get 'region/:url_name' => 'locations#region'
  get 'regions/:url_name' => 'locations#region', :as => :region

  get 'emails/welcome-to-sola' => 'emails#welcome_to_sola'

  match "forgot-password" => 'forgot_password#form', :via => [:get, :post], :as => :forgot_password_form
  match "forgot-password/reset" => 'forgot_password#reset', :via => [:get, :post], :as => :forgot_password_reset

  match 'sessions' => 'sessions#index', :via => [:get, :post]
  match 'sola-sessions/portland' => 'sessions#portland', :via => [:get, :post], :as => :portland_session
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
    namespace :v1 do
      match 'locations' => 'locations#index', :via => [:get, :post]
      match 'locations/:id' => 'locations#show', :via => [:get, :post]
    end

    namespace :v2 do
      match 'locations' => 'locations#index', :via => [:get, :post]
      match 'locations/:id' => 'locations#show', :via => [:get, :post]
    end

    namespace :v3 do
      resources :hubspot_webhooks, only: %i[create]
      resources :rent_manager_webhooks, only: %i[create]
    end
  end

  match '/cms/save-lease' => 'cms#save_lease', :via => [:get, :post], :as => :cms_save_lease
  match '/cms/save-stylist' => 'cms#save_stylist', :via => [:get, :post], :as => :cms_save_stylist

  match '/cms/locations-select' => 'cms#locations_select', :via => [:get, :post], :as => :cms_locations_select
  match '/cms/studios-select' => 'cms#studios_select', :via => [:get, :post], :as => :cms_studios_select
  match '/cms/stylists-select' => 'cms#stylists_select', :via => [:get, :post], :as => :cms_stylists_select

  match '/cms/s3-presigned-post' => 'cms#s3_presigned_post', :via => [:get, :post], :as => :cms_s3_presigned_post

  # Brazil URLs
  match '/sejasola' => 'brazil#sejasola', :via => [:get, :post], :as => :sejasola

  get "/:url_name" => 'redirect#short'
end

# == Route Map
#
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
#                             pro_engine          /                                                             Pro::Engine
#                               ckeditor          /ckeditor                                                     Ckeditor::Engine
#                                   home GET      /                                                             home#index
#                                new_cms GET      /new-cms(.:format)                                            home#new_cms
#                                   root GET      /                                                             home#index
#                                        GET      /robots.txt(.:format)                                         home#robots
#                                        GET      /google575b4ff16cfb013a.html(.:format)                        home#google_verification
#                                        GET      /BingSiteAuth.xml(.:format)                                   home#bing_verification
#                                        GET      /sitemap.xml(.:format)                                        home#sitemap
#                            franchising GET      /franchising(.:format)                                        home#franchising
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
#                       api_v1_locations GET|POST /api/v1/locations(.:format)                                   api/v1/locations#index
#                                 api_v1 GET|POST /api/v1/locations/:id(.:format)                               api/v1/locations#show
#                       api_v2_locations GET|POST /api/v2/locations(.:format)                                   api/v2/locations#index
#                                 api_v2 GET|POST /api/v2/locations/:id(.:format)                               api/v2/locations#show
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
#
# Routes for Ckeditor::Engine:
#         pictures GET    /pictures(.:format)             ckeditor/pictures#index
#                  POST   /pictures(.:format)             ckeditor/pictures#create
#          picture DELETE /pictures/:id(.:format)         ckeditor/pictures#destroy
# attachment_files GET    /attachment_files(.:format)     ckeditor/attachment_files#index
#                  POST   /attachment_files(.:format)     ckeditor/attachment_files#create
#  attachment_file DELETE /attachment_files/:id(.:format) ckeditor/attachment_files#destroy
