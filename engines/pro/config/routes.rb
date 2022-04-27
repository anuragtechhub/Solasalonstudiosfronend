# frozen_string_literal: true

Pro::Engine.routes.draw do
  root 'splash#index'

  match '/r/:public_id' => 'redirect#short_link', :via => %i[get post]

  # password pages
  match 'forgot-password' => 'password#forgot', :via => %i[get post], :as => :forgot_password
  match 'reset-password/:id' => 'password#reset', :via => %i[get post], :as => :reset_password

  # api
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'classes' => 'classes#index', :via => %i[get post]
      match 'classes_load_more/:id' => 'classes#load_more', :via => %i[get post]
      match 'get_class' => 'classes#get', :via => %i[get post]

      match 'deals' => 'deals#index', :via => %i[get post]
      match 'deals_load_more' => 'deals#load_more', :via => %i[get post]
      match 'get_deal' => 'deals#get', :via => %i[get post]

      match 'tools' => 'tools#index', :via => %i[get post]
      match 'tools_load_more' => 'tools#load_more', :via => %i[get post]

      match 'videos' => 'videos#index', :via => %i[get post]
      match 'videos_load_more' => 'videos#load_more', :via => %i[get post]
      match 'videos_search' => 'videos#search', :via => %i[get post]
      match 'videos_recommended' => 'videos#recommended', :via => %i[get post]
      match 'videos_log_view' => 'videos#log_view', :via => %i[get post]
      match 'videos_watch_later' => 'videos#watch_later', :via => %i[get post]
      match 'video_history_load_more' => 'videos#history_load_more', :via => %i[get post]
      match 'video_watch_later_load_more' => 'videos#watch_later_load_more', :via => %i[get post]
      match 'get_video' => 'videos#get', :via => %i[get post]

      match 'brands' => 'brands#index', :via => %i[get post]
      match 'brands/:id' => 'brands#show', :via => %i[get post]
      match 'get_brand' => 'brands#get', :via => %i[get post]

      match 'blogs' => 'blogs#index', :via => %i[get post]
      match 'blogs_load_more' => 'blogs#load_more', :via => %i[get post]
      match 'blogs_search' => 'blogs#search', :via => %i[get post]

      match 'users/find' => 'users#find', :via => %i[get post]
      match 'users/page_url' => 'users#page_url', :via => %i[get post]
      match 'users/active_check' => 'users#active_check', :via => %i[get post]
      match 'users/platform_version' => 'users#platform_version', :via => %i[get post]

      # all content
      match 'content/load' => 'content#load', :via => %i[get post], :as => :load_content

      match 'sessions/user' => 'sessions#user', :via => %i[get post]
      match 'sessions/content' => 'sessions#content', :via => %i[get post]

      match 'sessions/sign_in' => 'sessions#sign_in', :via => %i[get post]
      match 'sessions/sign_up' => 'sessions#sign_up', :via => %i[get post]

      match 'sessions/forgot_password' => 'sessions#forgot_password', :via => %i[get post]
      match 'sessions/reset_password' => 'sessions#reset_password', :via => %i[get post]

      match 'short_links/:public_id' => 'short_links#get', :via => %i[get post]

      match 'notifications/token' => 'notifications#token', :via => %i[get post]
      match 'notifications/dismiss' => 'notifications#dismiss', :via => %i[get post]

      match 'update_my_sola_website' => 'update_my_sola_website#submit', :via => %i[get post]
    end

    namespace :v2 do
      match 'classes' => 'classes#index', :via => %i[get post]
      match 'classes_load_more/:id' => 'classes#load_more', :via => %i[get post]
      match 'get_class' => 'classes#get', :via => %i[get post]

      match 'deals' => 'deals#index', :via => %i[get post]
      match 'deals_load_more' => 'deals#load_more', :via => %i[get post]
      match 'get_deal' => 'deals#get', :via => %i[get post]

      match 'leases/studio-agreement' => 'leases#studio_agreement', :via => %i[get post]
      match 'leases/save_lease_agreement_file_url' => 'leases#save_lease_agreement_file_url', :via => %i[get post]

      match 'tools' => 'tools#index', :via => %i[get post]
      match 'tools_load_more' => 'tools#load_more', :via => %i[get post]

      match 'videos' => 'videos#index', :via => %i[get post]
      match 'videos_load_more' => 'videos#load_more', :via => %i[get post]
      match 'videos_search' => 'videos#search', :via => %i[get post]
      match 'videos_recommended' => 'videos#recommended', :via => %i[get post]
      match 'videos_log_view' => 'videos#log_view', :via => %i[get post]
      match 'videos_watch_later' => 'videos#watch_later', :via => %i[get post]
      match 'video_history_load_more' => 'videos#history_load_more', :via => %i[get post]
      match 'video_watch_later_load_more' => 'videos#watch_later_load_more', :via => %i[get post]
      match 'get_video' => 'videos#get', :via => %i[get post]

      match 'brands' => 'brands#index', :via => %i[get post]
      match 'brands/:id' => 'brands#show', :via => %i[get post]
      match 'get_brand' => 'brands#get', :via => %i[get post]

      match 'blogs' => 'blogs#index', :via => %i[get post]
      match 'blogs_load_more' => 'blogs#load_more', :via => %i[get post]
      match 'blogs_search' => 'blogs#search', :via => %i[get post]

      match 'users/find' => 'users#find', :via => %i[get post]
      match 'users/page_url' => 'users#page_url', :via => %i[get post]
      match 'users/active_check' => 'users#active_check', :via => %i[get post]
      match 'users/platform_version' => 'users#platform_version', :via => %i[get post]

      match 'save-event' => 'events#save', :via => %i[get post]

      # all content
      match 'content/load' => 'content#load', :via => %i[get post], :as => :load_content

      match 'sessions/user' => 'sessions#user', :via => %i[get post]
      match 'sessions/content' => 'sessions#content', :via => %i[get post]

      match 'sessions/sign_in' => 'sessions#sign_in', :via => %i[get post]
      match 'sessions/sign_up' => 'sessions#sign_up', :via => %i[get post]

      match 'sessions/forgot_password' => 'sessions#forgot_password', :via => %i[get post]
      match 'sessions/reset_password' => 'sessions#reset_password', :via => %i[get post]
      match 'sessions/change_password' => 'sessions#change_password', :via => [:post]

      match 'short_links/:public_id' => 'short_links#get', :via => %i[get post]

      match 'notifications/token' => 'notifications#token', :via => %i[get post]
      match 'notifications/dismiss' => 'notifications#dismiss', :via => %i[get post]

      match 'update_my_sola_website' => 'update_my_sola_website#submit', :via => %i[get post]
      match 'update_my_sola_website/walkins' => 'update_my_sola_website#walkins', :via => %i[get post]
    end

    namespace :v3 do
      resources :blogs, only: %i[index show]
      resources :brands, only: %i[index show]
      resources :categories, only: %i[index]
      resources :deals, only: %i[index show]
      resources :devices, param: :token, only: %i[index show create update]
      resources :events, only: %i[create]
      resources :notifications, only: %i[index create destroy]
      resource  :registration, only: %i[create]
      resources :reset_passwords, only: %i[create update]
      resources :saved_items, only: %i[index show create]
      resources :saved_searches, only: %i[index create]
      resources :search, only: %i[index]
      resource  :session, only: %i[create]
      resources :sola_classes, only: %i[index show]
      resources :tools, only: %i[index show]
      resources :users, only: %i[update] do
        collection do
          get :has_password
          get :current
          get :shopify_url
        end
      end
      resources :videos, only: %i[index show]
      resources :webinars, only: %i[index show]
      resources :education_hero_images, only: %i[index]
      resource :update_my_sola_website, only: %i[create] do
        collection do
          post :walkins
        end
      end
    end
  end
end
