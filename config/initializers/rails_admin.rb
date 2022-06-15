# frozen_string_literal: true

Dir[Rails.root.join('app', 'rails_admin', '**/*.rb')].sort.each { |file| require file }

# TODO: temp. remove it after updating to Rails 5
module ActionController
  module Live
    class Response
      private

        def before_sending
          # super
          # request.cookie_jar.commit!
          # headers.freeze
        end
    end
  end
end
# TODO: end

module RailsAdmin
  class EnhancedController < ApplicationController
    include ActionController::Live
  end
end

module ActiveRecord
  module RailsAdminEnum
    def enum(definitions)
      super
      definitions.each do |name, _values|
        define_method("#{name}_enum") { self.class.send(name.to_s.pluralize).to_a }
        define_method("#{name}=") do |value|
          if value.is_a?(String) && (value.to_i.to_s == value)
            super value.to_i
          else
            super value
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend ActiveRecord::RailsAdminEnum

require Rails.root.join('lib/rails_admin/config/fields/types/citext')

RailsAdmin.config do |config|
  config.parent_controller = '::RailsAdmin::EnhancedController'

  # config.compact_show_view = false

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.authorize_with :cancan

  config.current_user_method(&:current_admin)

  # config.current_user_method do
  #   current_admin
  # end

  # config.audit_with :paper_trail, 'Admin', 'PaperTrail::Version'
  config.excluded_models = %w[Account BrandCountry BrandsSolaClasses DealCountry
                              GetFeatured ResetPassword ExpressionEngine SolaClassCountry User
                              Moz SavedSearch Support SupportCategory ProBeautyIndustry ProBeautyIndustryCategory
                              EducationHeroImageCountry NotificationRecipient
                              EmailEvent TerminatedStylist DealCategory DealCategoryDeal Taggable TagsVideo BlogCategory
                              BlogBlogCategory BlogCountry Categoriable Visit HubspotEvent HubspotLog SolaClassRegionCountry
                              SolaClassCategory ShortLink RecurringCharge Ckeditor::AttachmentFile Ckeditor::Asset Ckeditor::Picture
                              UserableNotification UserNotification Distributor VideoView VideoCountry WatchLater SavedItem UserAccessToken
                              PgSearchDocument HomeButtonCountry ToolCategory ToolCountry ToolCategoryTool Brandable Country
                              Lease Studio VideoCategoryVideo VideoCategory HomeHeroImageCountry SideMenuItemCountry Device
                              FranchisingRequest BrandLink Event]

  config.label_methods.unshift :display_name

  config.label_methods = %i[title name]

  config.actions do
    # root actions
    dashboard # mandatory

    # collection actions
    index # mandatory
    new do
      except ['Event']
      except ['GlossGeniusLog']
      except ['CallfireLog']
    end
    show
    # export do
    #   except %w[Stylist StylistMessage Report ContactInquiries RequestTourInquiry BookNowBooking]
    # end
    export
    # history_index
    bulk_delete

    # member actions
    edit do 
      except ['GlossGeniusLog']
      except ['CallfireLog']
    end
    delete
    # history_show
    # show_in_app
    custom_export
  end

  config.model 'SejaSola' do
    visible do
      ENV.fetch('LOCATION_COUNTRY_INCLUSION', nil) == 'BR'
    end
  end

  config.model 'BookNowBooking' do
    navigation_label 'Sola Salons'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end

    show do
      field :time_range
      field :location
      field :query
      field :services
      field :stylist
      field :booking_user_name
      field :booking_user_phone
      field :booking_user_email
      field :total
      field :created_at
    end

    export do
      field :id
      field :time_range
      field :location_id
      field :query
      field :services
      field :stylist_id
      field :booking_user_name
      field :booking_user_phone
      field :booking_user_email
      field :referring_url
      field :total
      field :created_at
      field :updated_at
    end
  end

  # General

  config.model 'Admin' do
    navigation_label 'General'
    # visible do
    #   bindings[:controller]._current_user.franchisee != true
    # end
    label 'My Account'
    label_plural 'My Account'
    list do
      field :email do
        label 'Username'
      end
      field :email_address
      field :franchisee do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :sign_in_count
      field :last_sign_in_at
    end
    show do
      field :email do
        label 'Username'
      end
      field :email_address
      field :franchisee do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      group 'Text and Email Integration' do
        label 'Text and Email Integration'
        field :mailchimp_api_key
        field :callfire_app_login
        field :callfire_app_password
      end
      field :sign_in_count
      field :last_sign_in_at
    end
    edit do
      field :email do
        label 'Username'
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end

      field :email_address
      field :password
      field :password_confirmation
      field :franchisee do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      group 'Text and Email Integration' do
        label 'Text and Email Integration'
        field :mailchimp_api_key
        field :callfire_app_login
        field :callfire_app_password
      end
      group 'Sola Pro' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :sola_pro_country_admin do
          help "If this field is set, this admin will have access to manage Sola Pro content for their country. The country should be the 2 character country code (e.g. 'US' for United States, 'CA' for Canada)"
        end
      end
    end
  end

  config.model 'Category' do
    navigation_label 'General'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :id
      field :name
      field :slug
      field :created_at
      field :updated_at
    end
  end

  config.model 'Tag' do
    navigation_label 'General'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :id
      field :name
      field :created_at
      field :updated_at
    end
  end

  # Sola Salons

  config.model 'Article' do
    navigation_label 'Sola Salons'
    # visible do
    #   bindings[:controller]._current_user.franchisee != true
    # end
    list do
      field :title
      field :article_url
      field :summary
      field :location
      field :created_at
    end
    show do
      field :title
      field :article_url
      field :image do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
      end
      field :summary do
        pretty_value do
          value.html_safe
        end
      end
      field :location
      field :display_setting do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
    edit do
      field :title
      field :article_url
      field :image do
        help 'Required. Image dimensions should be 375 x 375'
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
        delete_method :delete_image
      end
      field :summary, :ck_editor
      # field :body, :ck_editor
      field :location do
        help 'In order to have an article show up on more than one location page, you will need to create separate articles for each location page'
      end
      field :display_setting do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :created_at
    end
  end

  config.model 'Blog' do
    navigation_label 'Sola Salons'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :title
      field :url_name
      field :status
      field :summary
      field :author do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :created_at
    end
    show do
      field :title
      field :url_name do
        label 'URL Name'
        pretty_value do
          "#{value}<br><br>#{bindings[:view].link_to('View in website', bindings[:view].main_app.show_blog_preview_path(bindings[:object]))}".html_safe
        end
      end
      field :canonical_url do
        label 'Canonical URL Name'
      end
      field :status
      field :publish_date
      field :image do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
      end
      field :meta_description
      field :summary do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :body do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :author do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :contact_form_visible

      field :categories do
        label 'Categories'
      end
      field :tags do
        label 'Tags'
      end
      group 'Publish' do
        field :status
        field :publish_date
      end
      group 'Carousel' do
        field :carousel_image
        field :carousel_text
      end
      group 'Tracking' do
        field :fb_conversion_pixel
      end
    end
    edit do
      field :title
      field :url_name do
        label 'URL Name'
      end
      field :canonical_url do
        label 'Canonical URL Name'
      end
      field :image do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
        delete_method :delete_image
      end
      field :meta_description
      field :summary
      field :body, :ck_editor
      field :author
      field :contact_form_visible
      field :categories do
        label 'Categories'
      end
      field :tags do
        label 'Tags'
      end
      group 'Publish' do
        field :status
        field :publish_date do
          help 'Times are saved in UTC which is 6 hours ahead of Denver<br>(e.g. 18:30 UTC is 12:30 in Denver)'.html_safe
        end
      end
      group 'Carousel' do
        active false
        field :carousel_image do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_carousel_image
        end
        field :carousel_text
      end
      group 'Tracking' do
        active false
        field :fb_conversion_pixel
      end
      group 'Countries' do
        active false
        field :countries do
          inline_add false
        end
      end
    end
  end

  config.model 'Location' do
    navigation_label 'Sola Salons'
    list do
      field :id do
        searchable true
      end
      field :name
      field :url_name do
        label 'URL Name'
      end
      field :address_1
      field :city
      field :state
      field :msa do
        label 'MSA'
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :admin do
        label 'Franchisee'
        searchable %i[email email_address]
        queryable true
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
    show do
      group :general do
        field :name
        field :url_name do
          label 'URL Name'
        end
        field :description do
          pretty_value do
            value.html_safe
          end
        end
        field :description_long do
          visible false
        end
        field :description_short do
          visible false
        end
        field :open_time do
          help 'This will be used in directory listings (e.g. Google My Business) so customers know what time this Sola location opens.'
          visible false
        end
        field :close_time do
          help 'This will be used in directory listings (e.g. Google My Business) so customers know what time this Sola location closes.'
          visible false
        end
        field :msa do
          label 'MSA'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :admin do
          label 'Franchisee'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :store_id do
          label 'Store ID'
        end
        field :status
      end
      group :contact do
        field :general_contact_name do
          label 'General Contact Name'
        end
        field :email_address_for_inquiries do
          label 'Email Address for Inquiries'
        end
        field :email_address_for_reports do
          label 'Email Address for Reports'
        end
        field :email_address_for_hubspot do
          label 'Email Address For Hubspot'
        end
        field :emails_for_stylist_website_approvals do
          label 'Email Addresses For Stylist Website Approvals'
        end
        field :phone_number
      end
      group :address do
        field :address_1
        field :address_2
        field :city
        field :state do
          label 'State/Province'
        end
        field :postal_code
        field :country
        field :latitude
        field :longitude
        field :custom_maps_url do
          label 'Custom Maps URL'
          help 'If you specify a custom maps URL, it will be used for your Map It link instead of using the link auto-generated from your address'
        end
      end
      group :promotions do
        field :move_in_special
        field :open_house do
          label 'Special Callout'
        end
      end
      group :social do
        field :facebook_url
        field :instagram_url
        field :twitter_url
      end
      group :website do
        field :chat_code
        field :tracking_code
      end
      group :images do
        field :image_1 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_1_alt_text
        field :image_2 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_2_alt_text
        field :image_3 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_3_alt_text
        field :image_4 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_4_alt_text
        field :image_5 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_5_alt_text
        field :image_6 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_6_alt_text
        field :image_7 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_7_alt_text
        field :image_8 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_8_alt_text
        field :image_9 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_9_alt_text
        field :image_10 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_10_alt_text
        field :image_11 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_11_alt_text
        field :image_12 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_12_alt_text
        field :image_13 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_13_alt_text
        field :image_14 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_14_alt_text
        field :image_15 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_15_alt_text
        field :image_16 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_16_alt_text
        field :image_17 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_17_alt_text
        field :image_18 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_18_alt_text
        field :image_19 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_19_alt_text
        field :image_20 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_20_alt_text
      end
      group '360 Tours' do
        label '360 Tours'
        field :tour_iframe_1 do
          label 'Tour #1'
        end
        field :tour_iframe_2 do
          label 'Tour #2'
        end
        field :tour_iframe_3 do
          label 'Tour #3'
        end
      end
      group 'Text and Email Integration' do
        label 'Text and Email Integration'
        field :mailchimp_list_ids do
          help 'To sync to more than one Mailchimp list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
        field :callfire_list_ids do
          help 'To sync to more than one CallFire list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
      end
      group :rockbot do
        label 'Rockbot'
        active false
        field :walkins_enabled do
          label 'Walk-ins Enabled'
          help 'If set to yes, there will be a toggle switch inside Sola Pro to turn on/off taking walk-ins for each salon professional at this location.'
        end
        field :max_walkins_time do
          label 'Max Walk-ins Time'
          help 'This field will set the maximum duration a salon professional at this location may set their taking walk-ins setting inside Sola Pro.'
        end
        field :walkins_end_of_day do
          label 'Walk-ins End of Day'
          help 'If set, this is the time at the end of the day where all salon professionals talking walk-ins at this location should be automatically turned off.'
        end
        field :walkins_timezone do
          label 'Walk-ins Time Zone'
          help 'In order to turn off walk-ins automatically at the correct time, please select the time zone of this location'
        end
        field :floorplan_image do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :rockbot_manager_email
      end
      group :rent_manager do
        label 'Rent Manager'
        active false
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :rent_manager_property_id do
          label 'Rent Manager Property ID'
        end
        field :rent_manager_location_id do
          label 'Rent Manager Location ID'
        end
        field :service_request_enabled do
          help 'If set to "Yes", there will be a Service Request button visible in Sola Pro connected to your Rent Manager account.'
        end
      end
    end
    edit do 
      field 'load_location_js', :hidden do
        def render
          bindings[:view].render partial: 'load_location_js'
        end
      end
      group :general do
        field :name do
          label 'Location Name'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :description, :ck_editor
        field :description_long do
          visible false
          help 'This description is a max of 1000 characters and may not contain HTML or special characters. It is used for online directory listings (e.g. Google My Business)'
        end
        field :description_short do
          visible false
          help 'This description is a max of 200 characters and may not contain HTML or special characters. It is used for online directory listings (e.g. Google My Business)'
        end
        field :open_time do
          visible false
          help 'This time will be used in directory listings (e.g. Google My Business) so customers know what time this Sola location opens.'
        end
        field :close_time do
          visible false
          help 'This will be used in directory listings (e.g. Google My Business) so customers know what time this Sola location closes.'
        end
        field :msa do
          label 'MSA'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :admin do
          label 'Franchisee'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :store_id do
          label 'Store ID'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :status do
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
      end
      group :contact do
        field :general_contact_name do
          label 'General Contact Name'
        end
        field :email_address_for_inquiries do
          label 'Email Address for Inquiries'
        end
        field :email_address_for_reports do
          label 'Email Address for Reports'
        end
        field :email_address_for_hubspot do
          label 'Email Address For Hubspot'
          help 'If provided Hubspot will use this email address - not the email address for inquries - to match contacts.'
        end
        field :emails_for_stylist_website_approvals do
          label 'Email Addresses For Stylist Website Approvals'
          help "Comma separated emails. If blank - emails will be send to location's owner."
        end
        field :phone_number do
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
      end
      group :address do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :address_1
        field :address_2
        field :city
        field :state do
          label 'State/Province'
        end
        field :postal_code
        field :country
        field :latitude do
          help 'The latitude will be automatically set when a valid address is entered. You do not need to set the latitude manually (but you can if you really want to)'
        end
        field :longitude do
          help 'The longitude will be automatically set when a valid address is entered. You do not need to set the longitude manually (but you can if you really want to)'
        end
        field :custom_maps_url do
          label 'Custom Maps URL'
          help 'If you specify a custom maps URL, it will be used for your Map It link instead of using the link auto-generated from your address'
        end
      end
      group :promotions do
        active false
        field :move_in_special
        field :open_house do
          label 'Special Callout'
        end
      end
      group :social do
        active false
        field :facebook_url
        field :instagram_url
        field :twitter_url
      end
      group :website do
        active false
        field :chat_code
        field :tracking_code
      end
      group :images do
        active false
        field :image_1 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_1
        end
        field :image_1_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_2 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_2
        end
        field :image_3_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_3 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_3
        end
        field :image_3_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_4 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_4
        end
        field :image_4_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_5 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_5
        end
        field :image_5_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_6 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_6
        end
        field :image_6_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_7 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_7
        end
        field :image_7_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_8 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_8
        end
        field :image_8_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_9 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_9
        end
        field :image_9_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_10 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_10
        end
        field :image_10_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_11 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_11
        end
        field :image_11_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_12 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_12
        end
        field :image_12_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_13 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_13
        end
        field :image_13_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_14 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_14
        end
        field :image_14_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_15 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_15
        end
        field :image_15_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_16 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_16
        end
        field :image_16_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_17 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_17
        end
        field :image_17_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_18 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_18
        end
        field :image_18_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_19 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_19
        end
        field :image_19_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_20 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_20
        end
        field :image_20_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
      end
      group '360 Tours' do
        label '360 Tours'
        active false
        field :tour_iframe_1 do
          label 'Tour #1'
          help "If you need help finding your tour iframe code, please <a href='http://www.ambientlight.co.uk/google-maps-business-view-virtual-tours/add-your-tour-to-your-website' target='_blank'>click here</a>".html_safe
        end
        field :tour_iframe_2 do
          label 'Tour #2'
          help "If you need help finding your tour iframe code, please <a href='http://www.ambientlight.co.uk/google-maps-business-view-virtual-tours/add-your-tour-to-your-website' target='_blank'>click here</a>".html_safe
        end
        field :tour_iframe_3 do
          label 'Tour #3'
          help "If you need help finding your tour iframe code, please <a href='http://www.ambientlight.co.uk/google-maps-business-view-virtual-tours/add-your-tour-to-your-website' target='_blank'>click here</a>".html_safe
        end
      end
      group 'Text and Email Integration' do
        label 'Text and Email Integration'
        active false
        field :mailchimp_list_ids do
          help 'To sync to more than one Mailchimp list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
        field :callfire_list_ids do
          help 'To sync to more than one CallFire list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
      end
      group :rockbot do
        label 'Rockbot'
        active false
        field :walkins_enabled do
          label 'Walk-ins Enabled'
          help 'If set to yes, there will be a toggle switch inside Sola Pro to turn on/off taking walk-ins for each salon professional at this location.'
        end
        field :max_walkins_time do
          label 'Max Walk-ins Time'
          help 'This field will set the maximum duration a salon professional at this location may set their taking walk-ins setting inside Sola Pro.'
        end
        field :walkins_end_of_day do
          label 'Walk-ins End of Day'
          help 'If set, this is the time at the end of the day where all salon professionals talking walk-ins at this location should be automatically turned off.'
        end
        field :walkins_timezone do
          label 'Walk-ins Time Zone'
          help 'In order to turn off walk-ins automatically at the correct time, please select the time zone of this location'
        end
        field :floorplan_image do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_floorplan_image
        end
        field :rockbot_manager_email
      end
      group :rent_manager do
        label 'Rent Manager'
        active false
        field :rent_manager_property_id do
          label 'Rent Manager Property ID'
        end
        field :rent_manager_location_id do
          label 'Rent Manager Location ID'
        end
        field :service_request_enabled do
          help 'If set to "Yes", there will be a Service Request button visible in Sola Pro connected to your Rent Manager account.'
        end
      end
    end
    export do
      field :id
      field :name
      field :url_name
      field :address_1
      field :address_2
      field :city
      field :state
      field :postal_code
      field :status
      field :email_address_for_inquiries
      field :phone_number
      field :general_contact_name
      field :description
      field :move_in_special
      field :open_house do
        label 'Special Callout'
      end
      field :website_url
      field :services_list
      field :facebook_url
      field :twitter_url
      field :instagram_url
      field :yelp_url
    end
  end

  config.model 'ConnectMaintenanceContact' do
    label 'Connect Maintenance Contact'
    label_plural 'Connect Maintenance Contacts'
    navigation_label 'Sola Salons'
  end

  config.model 'Msa' do
    label 'MSA'
    label_plural 'MSAs'
    navigation_label 'Sola Salons'
  end

  config.model 'MySolaImage' do
    navigation_label 'Sola Salons'
    visible do
      ENV.fetch('LOCATION_COUNTRY_INCLUSION', nil) != 'BR' && bindings[:controller]._current_user.franchisee != true
    end
    list do
      scopes [:completed]
      field :name
      field :instagram_handle
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :share_url
      field :approved
    end
    edit do
      field :approved
      field :name
      field :instagram_handle
      field :statement
      field :statement_variant
      field :image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
    end
    show do
      field :name
      field :instagram_handle
      field :statement
      field :statement_variant
      field :image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :share_url
      field :approved
      field :approved_at
      field :created_at
    end
  end

  config.model 'Sola10kImage' do
    navigation_label 'Sola Salons'
    visible do
      ENV.fetch('LOCATION_COUNTRY_INCLUSION', nil) != 'BR' && bindings[:controller]._current_user.franchisee != true
    end
    list do
      scopes [:completed]
      field :name
      field :instagram_handle
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :share_url
      field :approved
    end
    edit do
      field :approved
      field :name
      field :instagram_handle
      field :statement
      # field :statement_variant
      field :image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
    end
    show do
      field :name
      field :instagram_handle
      field :statement
      field :image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :generated_image do
        pretty_value do
          "<img src='#{value.url(:original)}' width='640' height='640' style='max-width:320px;height:auto;width:100%;' />".html_safe if value.present?
        end
      end
      field :share_url
      field :approved
      field :approved_at
      field :created_at
    end
  end

  config.model 'PartnerInquiry' do
    label 'Partner Inquiry'
    label_plural 'Partner Inquiries'
    navigation_label 'Sola Salons'
  end

  config.model 'RequestTourInquiry' do
    label 'Contact Inquiry'
    label_plural 'Contact Inquiries'
    navigation_label 'Sola Salons'
    list do
      filters %i[created_at how_can_we_help_you]
      field :name
      field :email
      field :phone
      field :location do
        searchable [:name]
        queryable true
      end
      field :i_would_like_to_be_contacted_value do
        label 'I Would Like To Be Contacted'
        searchable false
      end
      field :how_can_we_help_you do
        searchable true
        queryable true
      end
      field :created_at
      field :send_email_to_prospect do
        hide
        label 'Prospect Origin'
        searchable true
        queryable true
      end
      field :newsletter_value do
        label 'Newsletter Subscription'
        searchable false
      end
      field :canada_locations do
        hide
        searchable false
      end
      field :dont_see_your_location do
        hide
        searchable false
      end
    end
    show do
      field :location do
        label 'Location'
      end
      field :name
      field :email
      field :phone
      field :i_would_like_to_be_contacted_value do
        label 'I Would Like To Be Contacted'
      end
      field :how_can_we_help_you
      field :message
      field :contact_preference
      field :services
      field :dont_see_your_location
      field :state
      field :zip_code
      field :request_url do
        label 'Request URL'
      end
      field :send_email_to_prospect do
        label 'Prospect Origin'
      end
      field :utm_source do
        label 'UTM Source'
      end
      field :utm_medium do
        label 'UTM Medium'
      end
      field :utm_campaign do
        label 'UTM Campaign'
      end
      field :utm_content do
        label 'UTM Content'
      end
      field :newsletter_value do
        label 'Newsletter Subscription'
      end
      field :created_at
    end
    edit do
      field :location do
        label 'Location'
      end
      field :name
      field :email
      field :phone
      field :how_can_we_help_you
      field :message
      field :contact_preference
      field :services
      field :dont_see_your_location
      field :state
      field :zip_code
      field :request_url do
        label 'Request URL'
      end
      field :send_email_to_prospect do
        label 'Prospect Origin'
      end
      field :utm_source do
        label 'UTM Source'
      end
      field :utm_medium do
        label 'UTM Medium'
      end
      field :utm_campaign do
        label 'UTM Campaign'
      end
      field :utm_content do
        label 'UTM Content'
      end
      field :newsletter
      field :created_at
    end
    export do
      field :location_id do
        label 'Location'
      end
      field :name
      field :email
      field :phone
      field :how_can_we_help_you
      field :message
      field :contact_preference
      field :services
      field :dont_see_your_location
      field :state
      field :zip_code
      field :request_url do
        label 'Request URL'
      end
      field :send_email_to_prospect do
        label 'Prospect Origin'
      end
      field :utm_source do
        label 'UTM Source'
      end
      field :utm_medium do
        label 'UTM Medium'
      end
      field :utm_campaign do
        label 'UTM Campaign'
      end
      field :utm_content do
        label 'UTM Content'
      end
      field :newsletter
      field :created_at
    end
  end

  config.model 'Stylist' do
    label 'Salon Professional'
    label_plural 'Salon Professionals'
    navigation_label 'Sola Salons'
    list do
      scopes %i[active inactive]
      field :name
      field :url_name do
        label 'URL Name'
      end
      field :email_address
      field :location do
        searchable [:name]
        queryable true
      end
      field :business_name
      field :studio_number
    end
    show do
      group :general do
        field :id
        field :created_at
        field :updated_at
        field :name
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
        end
        field :biography do
          pretty_value do
            value.html_safe
          end
        end
        field :reserved do
          help 'If set to yes, the stylist will not have a Sola webpage, appear in the directory or in searches.'
        end
        field :status
        field :inactive_reason
      end
      group :contact do
        field :phone_number
        field :phone_number_display do
          help 'If set to hidden, the phone number will not be displayed anywhere on the Sola website'
        end
        field :email_address
        field :send_a_message_button do
          help 'If set to hidden, the Send a Message button will not be displayed on your salon professional webpage'
        end
      end
      group :business do
        field :location
        field :business_name
        field :studio_number
        field :work_hours
        field :accepting_new_clients
        field :walkins
        field :total_booknow_bookings do
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :total_booknow_revenue do
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
      end
      group :website do
        field :website_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
        field :booking_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
      end
      group :social do
        field :facebook_url
        field :google_plus_url
        field :instagram_url
        field :linkedin_url
        field :pinterest_url
        field :twitter_url
        field :yelp_url
        field :tik_tok_url
      end
      group :services do
        field :barber
        field :botox do
          label 'Botox/Fillers'
        end
        field :brows
        field :hair
        field :hair_extensions
        field :laser_hair_removal
        field :eyelash_extensions do
          label 'Lashes'
        end
        field :makeup
        field :massage
        field :microblading
        field :nails
        field :permanent_makeup
        field :skin do
          label 'Skincare'
        end
        field :tanning
        field :teeth_whitening
        field :threading
        field :waxing
        field :other_service do
          label 'Other'
        end
      end
      group :sola_pro do
        active false
        label 'Sola Pro and SolaGenius'
        field :has_sola_pro_login do
          label 'Has Sola Pro account'
          help 'If set to "Yes", the stylist has a Sola Pro account.'
        end
        field :sola_pro_platform do
          help 'The platform (e.g. iOS or Android) the stylist is using to access Sola Pro.'
        end
        field :sola_pro_version do
          help 'The version of the Sola Pro app the stylist is using.'
        end
      end
      group :solagenius do
        active false
        label 'SolaGenius'
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :has_sola_genius_account do
          label 'Has SolaGenius Account?'
        end
      end
      group :images do
        field :image_1 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_1_alt_text
        field :image_2 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_2_alt_text
        field :image_3 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_3_alt_text
        field :image_4 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_4_alt_text
        field :image_5 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_5_alt_text
        field :image_6 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_6_alt_text
        field :image_7 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_7_alt_text
        field :image_8 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_8_alt_text
        field :image_9 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_9_alt_text
        field :image_10 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :image_10_alt_text
      end
      group :testimonials do
        field :testimonial_1
        field :testimonial_2
        field :testimonial_3
        field :testimonial_4
        field :testimonial_5
        field :testimonial_6
        field :testimonial_7
        field :testimonial_8
        field :testimonial_9
        field :testimonial_10
      end
    end
    edit do
      field 'load_stylist_js', :hidden do
        def render
          bindings[:view].render partial: 'load_stylist_js'
        end
      end
      group :general do
        field :name
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
        end
        field :biography, :ck_editor
        field :reserved do
          help 'If set to yes, the stylist will not have a Sola webpage, appear in the directory or in searches.'
        end
        field :status
        field :inactive_reason
      end
      group :contact do
        field :phone_number
        field :phone_number_display do
          help 'If set to hidden, the phone number will not be displayed anywhere on the Sola website'
        end
        field :email_address
        field :send_a_message_button do
          help 'If set to hidden, the Send a Message button will not be displayed on your salon professional webpage'
        end
      end
      group :business do
        field :location do
          associated_collection_cache_all false # REQUIRED if you want to SORT the list as below
          associated_collection_scope do
            # bindings[:object] & bindings[:controller] are available, but not in scope's block!
            admin = bindings[:controller]._current_user
            proc do |scope|
              # scoping all Players currently, let's limit them to the team's league
              # Be sure to limit if there are a lot of Players and order them by position
              if admin.franchisee == true
                scope = scope.where(admin_id: admin.id)
              end
            end
          end
        end
        field :business_name do 
          label 'Salon Name'
        end  
        field :studio_number
        field :work_hours
        field :accepting_new_clients
        field :walkins
      end
      group :website do
        active false
        field :website_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
        field :booking_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
      end
      group :social do
        active false
        field :facebook_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :google_plus_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :instagram_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :linkedin_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :pinterest_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :twitter_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :yelp_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
        field :tik_tok_url do
          help 'Please use the full website address, including the "http://" portion of the URL'
        end
      end
      group :services do
        active false
        field :barber
        field :botox do
          label 'Botox/Fillers'
        end
        field :brows
        field :hair
        field :hair_extensions
        field :laser_hair_removal
        field :eyelash_extensions do
          label 'Lashes'
        end
        field :makeup
        field :massage
        field :microblading
        field :nails
        field :permanent_makeup
        field :skin do
          label 'Skincare'
        end
        field :tanning
        field :teeth_whitening
        field :threading
        field :waxing
        field :other_service do
          label 'Other'
          # html_attributes do
          #  {:maxlength => 18}
          # end
        end
      end
      group :images do
        active false
        field :image_1 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_1
        end
        field :image_1_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_2 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_2
        end
        field :image_2_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_3 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_3
        end
        field :image_3_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_4 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_4
        end
        field :image_4_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_5 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_5
        end
        field :image_5_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_6 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_6
        end
        field :image_6_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_7 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_7
        end
        field :image_7_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_8 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_8
        end
        field :image_8_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_9 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_9
        end
        field :image_9_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
        field :image_10 do
          pretty_value do
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_10
        end
        field :image_10_alt_text do
          help 'The alt text for an image describes what the image looks like (used by screen readers, the blind or visually impared and for search engine optimization)'
        end
      end
      group :testimonials do
        active false
        field :testimonial_1
        field :testimonial_2
        field :testimonial_3
        field :testimonial_4
        field :testimonial_5
        field :testimonial_6
        field :testimonial_7
        field :testimonial_8
        field :testimonial_9
        field :testimonial_10
      end
      group :password do
        active false
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :password
        field :password_confirmation
      end
    end
    export do
      field :id
      field :created_at
      field :updated_at
      field :name
      field :url_name
      field :email_address
      field :phone_number
      field :biography
      field :status
      field :has_sola_pro_login do
        label 'Has SolaPro account'
      end
      field :has_sola_genius_account do
        label 'Has SolaGenius account'
      end
      field :sola_pro_platform
      field :sola_pro_version
      field :location_name
      field :location_city
      field :location_state
      field :business_name
      field :studio_number
      field :work_hours
      field :accepting_new_clients
      field :walkins
      field :total_booknow_bookings do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :total_booknow_revenue do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :booking_url
      field :send_a_message_button
      field :hair
      field :skin
      field :nails
      field :massage
      field :microblading
      field :teeth_whitening
      field :hair_extensions
      field :eyelash_extensions
      field :makeup
      field :tanning
      field :waxing
      field :barber
      field :botox do
        label 'Botox/Fillers'
      end
      field :brows
      field :facebook_url
      field :google_plus_url
      field :instagram_url
      field :pinterest_url
      field :twitter_url
      field :yelp_url
      field :tik_tok_url
    end
  end

  config.model 'GlossGeniusLog' do 
    label 'Gloss Genius Log'
    label_plural 'Gloss Genius Logs'

    list do
      field :action_name
      field :ip_address
      field :host
      field :request_body 
    end
    show do
      field :action_name
      field :ip_address
      field :host
      field :request_body 
    end
  end  

  config.model 'StylistMessage' do
    navigation_label 'Sola Salons'
    label 'Stylist Message'
    label_plural 'Stylist Messages'
  end

  config.model 'Report' do
    navigation_label 'Sola Salons'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :report_type
      field :email_address
      field :processed_at
    end
    edit do
      field :report_type
      field :email_address
      field :parameters
    end
  end

  config.model 'UpdateMySolaWebsite' do
    navigation_label 'Sola Salons'
    visible true

    list do
      scopes %i[pending approved]
      group :general do
        field :name do
          help ' '
        end
        field :biography do
          pretty_value do
            value.html_safe if value.present?
          end
          help ' '
        end
      end
      group :contact do
        field :phone_number do
          help ' '
        end
        field :email_address do
          help ' '
        end
      end
      group :business do
        field :business_name do
          help ' '
        end
        field :work_hours do
          help ' '
        end
      end
      group :website do
        field :website_url do
          help ' '
        end
        field :booking_url do
          help ' '
        end
        field :reserved do
          help ' '
        end
      end
      group :social do
        field :facebook_url
        field :google_plus_url
        field :instagram_url
        field :linkedin_url
        field :pinterest_url
        field :twitter_url
        field :yelp_url
        field :tik_tok_url
      end
      group :services do
        field :barber
        field :botox do
          label 'Botox/Fillers'
        end
        field :brows
        field :hair
        field :hair_extensions
        field :laser_hair_removal
        field :eyelash_extensions do
          label 'Lashes'
        end
        field :makeup
        field :massage
        field :nails
        field :permanent_makeup
        field :skin do
          label 'Skincare'
        end
        field :tanning
        field :teeth_whitening
        field :threading
        field :waxing
        field :other_service do
          label 'Other'
        end
      end
      group :testimonials do
        field :testimonial_1 do
          label 'Testimonial #1'
          help ''
        end
        field :testimonial_2 do
          label 'Testimonial #2'
          help ''
        end
        field :testimonial_3 do
          label 'Testimonial #3'
          help ''
        end
        field :testimonial_4 do
          label 'Testimonial #4'
          help ''
        end
        field :testimonial_5 do
          label 'Testimonial #5'
          help ''
        end
        field :testimonial_6 do
          label 'Testimonial #6'
          help ''
        end
        field :testimonial_7 do
          label 'Testimonial #7'
          help ''
        end
        field :testimonial_8 do
          label 'Testimonial #8'
          help ''
        end
        field :testimonial_9 do
          label 'Testimonial #9'
          help ''
        end
        field :testimonial_10 do
          label 'Testimonial #10'
          help ''
        end
      end
      group :images do
        field :image_1 do
          label 'Image #1'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_1
        end
        field :image_2 do
          label 'Image #2'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_2
        end
        field :image_3 do
          label 'Image #3'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_3
        end
        field :image_4 do
          label 'Image #4'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_4
        end
        field :image_5 do
          label 'Image #5'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_5
        end
        field :image_6 do
          label 'Image #6'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_6
        end
        field :image_7 do
          label 'Image #7'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_7
        end
        field :image_8 do
          label 'Image #8'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_8
        end
        field :image_9 do
          label 'Image #9'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_9
        end
        field :image_10 do
          label 'Image #10'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_10
        end
      end
      field :approved
    end

    show do
      group :general do
        field :name do
          help ' '
        end
        field :biography do
          pretty_value do
            value.html_safe if value.present?
          end
        end
      end
      group :contact do
        field :phone_number do
          help ' '
        end
        field :email_address do
          help ' '
        end
      end
      group :business do
        field :business_name do
          help ' '
        end
        field :work_hours do
          help ' '
        end
      end
      group :website do
        field :website_url do
          help ' '
        end
        field :booking_url do
          help ' '
        end
        field :reserved do
          help ' '
        end
      end
      group :social do
        field :facebook_url
        field :google_plus_url
        field :instagram_url
        field :linkedin_url
        field :pinterest_url
        field :twitter_url
        field :yelp_url
        field :tik_tok_url
      end
      group :services do
        field :barber
        field :botox do
          label 'Botox/Fillers'
        end
        field :brows
        field :hair
        field :hair_extensions
        field :laser_hair_removal
        field :eyelash_extensions do
          label 'Lashes'
        end
        field :makeup
        field :massage
        field :nails
        field :permanent_makeup
        field :skin do
          label 'Skincare'
        end
        field :tanning
        field :teeth_whitening
        field :threading
        field :waxing
        field :other_service do
          label 'Other'
        end
      end
      group :testimonials do
        field :testimonial_1 do
          label 'Testimonial #1'
          help ''
        end
        field :testimonial_2 do
          label 'Testimonial #2'
          help ''
        end
        field :testimonial_3 do
          label 'Testimonial #3'
          help ''
        end
        field :testimonial_4 do
          label 'Testimonial #4'
          help ''
        end
        field :testimonial_5 do
          label 'Testimonial #5'
          help ''
        end
        field :testimonial_6 do
          label 'Testimonial #6'
          help ''
        end
        field :testimonial_7 do
          label 'Testimonial #7'
          help ''
        end
        field :testimonial_8 do
          label 'Testimonial #8'
          help ''
        end
        field :testimonial_9 do
          label 'Testimonial #9'
          help ''
        end
        field :testimonial_10 do
          label 'Testimonial #10'
          help ''
        end
      end
      group :images do
        field :image_1 do
          label 'Image #1'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_1
        end
        field :image_2 do
          label 'Image #2'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_2
        end
        field :image_3 do
          label 'Image #3'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_3
        end
        field :image_4 do
          label 'Image #4'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_4
        end
        field :image_5 do
          label 'Image #5'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_5
        end
        field :image_6 do
          label 'Image #6'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_6
        end
        field :image_7 do
          label 'Image #7'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_7
        end
        field :image_8 do
          label 'Image #8'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_8
        end
        field :image_9 do
          label 'Image #9'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_9
        end
        field :image_10 do
          label 'Image #10'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_10
        end
      end
      field :approved
    end

    edit do
      group :general do
        field :name do
          help ' '
        end
        field :biography, :ck_editor
      end
      group :contact do
        field :phone_number do
          help ' '
        end
        field :email_address do
          help ' '
        end
      end
      group :business do
        field :business_name do
          help ' '
        end
        field :work_hours do
          help ' '
        end
      end
      group :website do
        field :website_url do
          help ' '
        end
        field :booking_url do
          help ' '
        end
        field :reserved do
          help ' '
        end
      end
      group :social do
        field :facebook_url
        field :google_plus_url
        field :instagram_url
        field :linkedin_url
        field :pinterest_url
        field :twitter_url
        field :yelp_url
        field :tik_tok_url
      end
      group :services do
        field :barber
        field :botox do
          label 'Botox/Fillers'
        end
        field :brows
        field :hair
        field :hair_extensions
        field :laser_hair_removal
        field :eyelash_extensions do
          label 'Lashes'
        end
        field :makeup
        field :massage
        field :nails
        field :permanent_makeup
        field :skin do
          label 'Skincare'
        end
        field :tanning
        field :teeth_whitening
        field :threading
        field :waxing
        field :other_service do
          label 'Other'
        end
      end
      group :testimonials do
        field :testimonial_1 do
          label 'Testimonial #1'
          help ''
        end
        field :testimonial_2 do
          label 'Testimonial #2'
          help ''
        end
        field :testimonial_3 do
          label 'Testimonial #3'
          help ''
        end
        field :testimonial_4 do
          label 'Testimonial #4'
          help ''
        end
        field :testimonial_5 do
          label 'Testimonial #5'
          help ''
        end
        field :testimonial_6 do
          label 'Testimonial #6'
          help ''
        end
        field :testimonial_7 do
          label 'Testimonial #7'
          help ''
        end
        field :testimonial_8 do
          label 'Testimonial #8'
          help ''
        end
        field :testimonial_9 do
          label 'Testimonial #9'
          help ''
        end
        field :testimonial_10 do
          label 'Testimonial #10'
          help ''
        end
      end
      group :images do
        field :image_1 do
          label 'Image #1'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_1
        end
        field :image_2 do
          label 'Image #2'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_2
        end
        field :image_3 do
          label 'Image #3'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_3
        end
        field :image_4 do
          label 'Image #4'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_4
        end
        field :image_5 do
          label 'Image #5'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_5
        end
        field :image_6 do
          label 'Image #6'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_6
        end
        field :image_7 do
          label 'Image #7'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_7
        end
        field :image_8 do
          label 'Image #8'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_8
        end
        field :image_9 do
          label 'Image #9'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_9
        end
        field :image_10 do
          label 'Image #10'
          pretty_value do
            "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_image_10
        end
      end
      field :approved
    end
  end

  # Sola Pro

  config.model 'Brand' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :name
      field :website_url
    end
    show do
      field :name
      field :website_url
      field :image do
        label 'Color Image'
        help 'Ideal image size is 460 x 280'
      end
      field :brand_links do
        label 'Links'
      end
      group 'Settings' do
        field :introduction_video_heading_title
        field :events_and_classes_heading_title
      end
    end
    edit do
      field :name
      field :website_url
      field :image do
        label 'Color Image'
        help 'Ideal image size is 460 x 280'
      end
      field :brand_links do
        label 'Links'
      end
      group 'Settings' do
        field :introduction_video_heading_title
        field :events_and_classes_heading_title
      end
      group 'Countries' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end

        field :countries do
          inline_add false
        end
      end
    end
  end

  config.model 'ClassImage' do
    navigation_label 'Sola Pro'
    visible true
    list do
      field :name
      field :image_file_name
      field :thumbnail_file_name
    end
    show do
      field :name
      field :image_file_name
      field :thumbnail_file_name
      field :image do
        label 'Image'
        help 'Ideal image size is 460 x 280'
      end
      field :thumbnail do
        label 'Thumbnail'
        help 'Ideal image size is 460 x 280'
      end
    end
    edit do
      field :name
      field :image do
        label 'Image'
        help 'Ideal image size is 460 x 280'
      end
      field :thumbnail do
        label 'Thumbnail'
        help 'Ideal image size is 460 x 280'
      end
    end
  end

  config.model 'Deal' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :title
      field :brand
      field :categories
      field :tags
      field :description
      field :is_featured do
        searchable false
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
    show do
      field :title
      field :description
      field :brand
      field :categories
      field :tags
      field :image do
        help 'Ideal image size is 460 x 280'
      end
      field :file
      field :more_info_url
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
    edit do
      field :title
      field :description
      field :brand
      field :categories
      field :tags
      field :image do
        help 'Ideal image size is 460 x 280'
        delete_method :delete_image
      end
      field :file do
        delete_method :delete_file
      end
      field :more_info_url
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      group 'Countries' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end

        field :countries do
          inline_add false
        end
      end
    end
  end

  config.model 'EducationHeroImage' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
  end

  config.model 'SolaClass' do
    navigation_label 'Sola Pro'
    label 'Event and Class'
    label_plural 'Events and Classes'
    object_label_method do
      :label
    end
    list do
      field :title
      field :sola_class_region do
        label 'Region'
      end
      field :location
      field :address
      field :city
      field :state do
        label 'State/Province'
      end
      field :start_date
      field :end_date
    end
    show do
      field :title
      field :description
      field :class_image do
        help 'Ideal image size is 460 x 280'
      end
      field :category
      field :tags
      field :cost
      field :link_text
      field :link_url
      group 'When' do
        field :start_date
        field :start_time
        field :end_date
        field :end_time
      end
      group 'Where' do
        field :sola_class_region do
          label 'Region'
        end
        field :location
        field :address
        field :city
        field :state do
          label 'State/Province'
        end
      end
      group 'Who' do
        field :brands
      end
      field :file
      field :file_text do
        help 'Customize the file button text'
      end
    end
    edit do
      field :title
      field :description
      field :category
      field :class_image
      field :tags
      field :cost
      field :link_text
      field :link_url
      group 'When' do
        field :start_date
        field :start_time do
          help '(e.g 9:30am, 7pm, etc)'
        end
        field :end_date
        field :end_time do
          help '(e.g 9:30am, 7pm, etc)'
        end
      end
      group 'Where' do
        field :sola_class_region do
          label 'Region'
        end
        field :location
        field :address
        field :city
        field :state do
          label 'State/Province'
        end
        field :countries do
          label 'Countries'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
          visible false
        end
      end
      group 'Who' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :brands
      end
      group 'RSVP' do
        field :rsvp_email_address do
          label 'Email Address'
        end
        field :rsvp_phone_number do
          label 'Phone Number'
        end
      end
      field :file do
        delete_method :delete_file
      end
      field :file_text do
        help 'Customize the file button text'
      end
      field :video
    end
  end

  config.model 'HomeButton' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :image
      field :action_link
      field :position
      field :countries
    end
    show do
      field :image
      field :action_link
      field :position
      field :countries
    end
    edit do
      field :image do
        help 'Image should be 1500 x 500'
      end
      field :action_link do
        help 'This must be either a full URL (e.g. https://www.solasalonstudios.com) or it should be the name of a view inside the Sola Pro app (e.g. BlogsView, BrandsView, DealsView, EducationView, EventsAndClassesView, PerksProgramView, SolaGenius, ToolsAndResourcesView, MySolaProView, or VideosView)'
      end
      field :position
      field :countries do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
  end

  config.model 'HomeHeroImage' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :image
      field :action_link
      field :position
      field :countries
    end
    show do
      field :image
      field :action_link
      field :position
      field :countries
    end
    edit do
      field :image do
        help 'Image should be 1500 x 1000'
      end
      field :action_link do
        help 'This must be either a full URL (e.g. https://www.solasalonstudios.com) or it should be the name of a view inside the Sola Pro app (e.g. BlogsView, BrandsView, DealsView, EducationView, EventsAndClassesView, PerksProgramView, SolaGenius, ToolsAndResourcesView, MySolaProView, or VideosView)'
      end
      field :position
      field :countries do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
  end

  config.model 'Notification' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    show do
      group 'Content' do
        field :blog_id, :enum do
          label 'Blog'
          enum do
            Blog.all.map { |b| [b.title, b.id] }
          end
        end
        field :brand do
          inline_add false
          inline_edit false
        end
        field :deal do
          inline_add false
          inline_edit false
        end
        field :sola_class do
          label 'Event or Class'
          inline_add false
          inline_edit false
        end
        field :tool do
          label 'Tool or Resource'
          inline_add false
          inline_edit false
        end
        field :video do
          inline_add false
          inline_edit false
        end
      end
      group 'Push Notification' do
        field :title, :string do
          required true
          html_attributes do
            { maxlength: 65 }
          end
        end
        field :notification_text, :string do
          required true
          html_attributes do
            { maxlength: 235 }
          end
        end
        field :date_sent
      end
      field :stylists
      field :send_at
      field :date_sent
    end
    edit do
      group 'Content' do
        field :blog_id, :enum do
          label 'Blog'
          enum do
            Blog.all.map { |b| [b.title, b.id] }
          end
        end
        field :brand do
          inline_add false
          inline_edit false
        end
        field :deal do
          inline_add false
          inline_edit false
        end
        field :sola_class do
          label 'Event or Class'
          inline_add false
          inline_edit false
        end
        field :tool do
          label 'Tool or Resource'
          inline_add false
          inline_edit false
        end
        field :video do
          inline_add false
          inline_edit false
        end
      end
      group 'Push Notification' do
        field :title, :string do
          required true
          html_attributes do
            { maxlength: 65 }
          end
        end
        field :notification_text, :string do
          required true
          html_attributes do
            { maxlength: 235 }
          end
        end
        field :country do
          inline_add false
          inline_edit false
        end
      end
      group 'Recipients' do
        help 'Will be send to all users if blank'
        field :stylists do
          inline_add false

          associated_collection_scope do
            proc { |scope| scope.where.not(encrypted_password: '') }
          end
        end
      end

      field :send_at do
        help 'Will be send immediately if blank'
      end
    end
  end

  config.model 'ProductInformation' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
  end

  config.model 'SolaClassRegion' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    label 'Region'
    label_plural 'Regions'
    list do
      field :name
      field :countries
      field :position
    end
    edit do
      field :name
      field :countries
      field :position
    end
    show do
      field :name
      field :countries
      field :position
    end
  end

  config.model 'SideMenuItem' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :name
      field :action_link
      field :position
      field :countries
    end
    show do
      field :name
      field :action_link
      field :position
      field :countries
    end
    edit do
      field :name
      field :action_link do
        help 'This must be either a full URL (e.g. https://www.solasalonstudios.com) or it should be the name of a view inside the Sola Pro app (e.g. BlogsView, BrandsView, DealsView, EducationView, EventsAndClassesView, PerksProgramView, SolaGenius, ToolsAndResourcesView, MySolaProView, or VideosView)'
      end
      field :position
      field :countries do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
  end

  config.model 'SolaClassRegionState' do
    navigation_label 'Sola Pro'
    label 'State Region'
    label_plural 'State Regions'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
  end

  config.model 'Tool' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    label 'Tool and Resource'
    label_plural 'Tools and Resources'
    list do
      field :title
      field :description
      field :brand
      field :categories
      field :tags
      field :image
      field :file
      field :link_url
      field :youtube_url
    end
    show do
      field :title
      field :description
      field :brand
      field :categories
      field :tags
      field :image do
        help 'Ideal image size is 460 x 280'
      end
      field :file
      field :link_url
      field :youtube_url
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
    end
    edit do
      field :title
      field :description
      field :brand
      field :categories
      field :tags
      field :image do
        help 'Ideal image size is 460 x 280'
        delete_method :delete_image
      end
      field :file do
        delete_method :delete_file
      end
      field :link_url
      field :youtube_url
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      group 'Countries' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end

        field :countries do
          inline_add false
        end
      end
    end
  end

  config.model 'Video' do
    navigation_label 'Sola Pro'
    visible do
      bindings[:controller]._current_user.sola_pro_country_admin.present? || bindings[:controller]._current_user.franchisee != true
    end
    list do
      field :title
      field :webinar
      field :is_featured do
        searchable false
      end
      field :duration do
        help '(e.g. 11:10, 1:07:41, 3:42, etc)'
      end
      field :brand
      field :categories
      field :tags
    end
    show do
      field :title
      field :webinar
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      field :youtube_url
      field :duration do
        help '(e.g. 11:10, 1:07:41, 3:42, etc)'
      end
      field :tool do
        label 'Related Tool or Resource'
      end
      field :brand
      field :categories
      field :tags
      field :is_introduction
    end
    edit do
      field :title
      field :webinar
      field :youtube_url
      field :duration do
        help '(e.g. 11:10, 1:07:41, 3:42, etc)'
      end
      field :tool do
        label 'Related Tool or Resource'
      end
      field :brand
      field :categories
      field :tags
      field :is_introduction
      field :is_featured do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
      end
      group 'Countries' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end

        field :countries do
          inline_add false
        end
      end
    end
  end

  config.model 'SolaClass' do
    label 'Event and Class'
    label_plural 'Events and Classes'
    navigation_label 'Sola Pro'
    object_label_method do
      :label
    end
    list do
      field :title
      field :sola_class_region do
        label 'Region'
      end
      field :location
      field :address
      field :city
      field :state do
        label 'State/Province'
      end
      field :start_date
      field :end_date
    end
    show do
      field :title
      field :description
      field :class_image do
        help 'Ideal image size is 460 x 280'
      end
      field :category
      field :tags
      field :cost
      field :link_text
      field :link_url
      group 'When' do
        field :start_date
        field :start_time
        field :end_date
        field :end_time
      end
      group 'Where' do
        field :sola_class_region do
          label 'Region'
        end
        field :location
        field :address
        field :city
        field :state do
          label 'State/Province'
        end
      end
      group 'Who' do
        field :brands
      end
      field :file
      field :file_text do
        help 'Customize the file button text'
      end
    end
    edit do
      field :admin_id, :hidden do
      default_value do
        bindings[:view]._current_user.id
      end
      end
      field :title
      field :description
      field :category
      field :class_image
      field :tags
      field :cost
      field :link_text
      field :link_url
      group 'When' do
        field :start_date
        field :start_time do
          help '(e.g 9:30am, 7pm, etc)'
        end
        field :end_date
        field :end_time do
          help '(e.g 9:30am, 7pm, etc)'
        end
      end
      group 'Where' do
        field :sola_class_region do
          label 'Region'
        end
        field :location
        field :address
        field :city
        field :state do
          label 'State/Province'
        end
        field :countries do
          label 'Countries'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
          visible false
        end
      end
      group 'Who' do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :brands
      end
      group 'RSVP' do
        field :rsvp_email_address do
          label 'Email Address'
        end
        field :rsvp_phone_number do
          label 'Phone Number'
        end
      end
      field :file do
        delete_method :delete_file
      end
      field :file_text do
        help 'Customize the file button text'
      end
      field :video
    end
  end

  ### Franchsing

  config.model 'FranchisingForm' do
    label 'Franchsing Inquiry'
    label_plural 'Franchising Inquiries'
    navigation_label 'Sola Franchise'
    visible do
      ENV.fetch('LOCATION_COUNTRY_INCLUSION', nil) != 'BR' && bindings[:controller]._current_user.franchisee != true
    end
    list do
      scopes %i[usa ca]
    end
  end

  config.model 'FranchiseArticle' do
    label 'Franchise Press And Blog'
    label_plural 'Franchise Press And Blog'
    navigation_label 'Sola Franchise'
    visible do
      bindings[:controller]._current_user.franchisee != true
    end

    list do
      scopes %i[all press blog]
      field :title
      field :url
      field :summary
      field :author do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :created_at
    end
    show do
      field :kind
      field :country
      field :slug
      field :title
      field :url
      field :thumbnail do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
      end
      field :image do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
      end
      field :summary do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :body do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :author do
        pretty_value do
          value.html_safe if value.present?
        end
      end
      field :categories do
        label 'Categories'
      end
      field :tags do
        label 'Tags'
      end
    end
    edit do
      field 'load_franchise_article_js', :hidden do
        def render
          bindings[:view].render partial: 'load_franchise_article_js'
        end
      end
      field :kind
      field :country
      field :title
      field :url
      field :thumbnail do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
        delete_method :delete_thumbnail
      end
      field :image do
        pretty_value do
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
        delete_method :delete_image
      end
      field :summary
      field :body, :ck_editor
      field :author
      field :categories do
        label 'Categories'
      end
      field :tags do
        label 'Tags'
      end
    end
  end
end
