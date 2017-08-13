RailsAdmin.config do |config|
  
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.authorize_with :cancan

  config.current_user_method(&:current_admin)

  # config.current_user_method do
  #   current_admin
  # end

  # config.audit_with :paper_trail, 'Admin', 'PaperTrail::Version'

  # config.excluded_models << 'ResetPassword'
  # config.excluded_models << 'ExpressionEngine'
  # config.excluded_models << 'BlogCategory'
  # config.excluded_models << 'BlogBlogCategory'
  config.label_methods.unshift :display_name

  config.actions do
    # root actions
    dashboard                     # mandatory
 
    # collection actions
    index                         # mandatory
    new
    export
    # history_index
    bulk_delete
 
    # member actions
    show
    edit
    delete
    # history_show
    # show_in_app
  end

  config.model 'Account' do
    visible false
  end

  config.model 'Admin' do
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
      group 'External Services' do
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
      group 'External Services' do
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

  config.model 'Article' do
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
      # field :body do
      #   pretty_value do
      #     value.html_safe
      #   end
      # end
      field :location 
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
      #field :body, :ck_editor
      field :location do
        help 'In order to have an article show up on more than one location page, you will need to create separate articles for each location page'
      end   
      field :created_at
    end 
  end

  config.model 'Blog' do
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
          value.html_safe
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
      field :status
      field :publish_date
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
      field :body do
        pretty_value do
          value.html_safe
        end
      end
      field :author do
        pretty_value do
          value.html_safe
        end
      end
      field :blog_categories do
        label 'Categories'
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
      field :image do
        pretty_value do 
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe if value.present?
        end
        delete_method :delete_image
      end
      field :summary
      field :body, :ck_editor
      field :author
      field :blog_categories do
        label 'Categories'
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

  config.model 'BlogCategory' do
    visible false
    label 'Category'
    label_plural 'Categories'      
    edit do 
      field :name
      field :url_name
    end
  end

  config.model 'BlogBlogCategory' do
    visible false
  end

  config.model 'FranchisingRequest' do
    label 'Franchsing Inquiry'
    label_plural 'Franchising Inquiries'
  end

  config.model 'BlogCountry' do
    visible false
  end

  config.model 'Country' do
    visible false  
  end

  config.model 'Location' do    
    list do
      field :name
      field :url_name do
        label 'URL Name'
      end
      field :address_1
      field :city
      field :state
      field :msa do
        label "MSA"
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
    end
    show do
      group :general do
        #field :legacy_id
        field :name
        field :url_name do
          label 'URL Name'
        end
        field :description do
          pretty_value do
            value.html_safe
          end
        end
        field :admin do
          label 'Franchisee'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :msa do
          label "MSA"
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
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
        field :open_house
      end
      group :social do
        field :facebook_url
        field :instagram_url
        #field :pinterest_url
        field :twitter_url
        #field :yelp_url
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
      group :digital_directory do
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :floorplan_image do
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:directory)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_11 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end
        field :directory_image_12 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
        end                                        
      end
      group 'External Services' do
        field :mailchimp_list_ids do
          help 'To sync to more than one Mailchimp list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
        field :callfire_list_ids do
          help 'To sync to more than one CallFire list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
      end
    end
    edit do
      group :general do
        field :name
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
          visible do
            bindings[:controller]._current_user.franchisee != true
          end
        end
        field :description, :ck_editor
        field :msa do
          label "MSA"
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
        field :country do
          help "The country should be the 2 character country code (e.g. 'US' for United States, 'CA' for Canada)"
        end
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
        field :open_house
      end
      group :social do
        active false
        field :facebook_url
        field :instagram_url
        #field :pinterest_url
        field :twitter_url
        #field :yelp_url
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
      group :digital_directory do
        active false
        visible do
          bindings[:controller]._current_user.franchisee != true
        end
        field :floorplan_image do
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:directory)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_floorplan_image
        end
        field :directory_image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_1
        end
        field :directory_image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_2
        end
        field :directory_image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_3
        end
        field :directory_image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_4
        end
        field :directory_image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_5
        end
        field :directory_image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_6
        end
        field :directory_image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_7
        end
        field :directory_image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_8
        end
        field :directory_image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_9
        end
        field :directory_image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_10
        end
        field :directory_image_11 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_11
        end
        field :directory_image_12 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:carousel)}' /></a>".html_safe if value.present?
          end
          delete_method :delete_directory_image_12
        end                                        
      end
      group 'External Services' do
        active false
        field :mailchimp_list_ids do
          help 'To sync to more than one Mailchimp list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
        field :callfire_list_ids do
          help 'To sync to more than one CallFire list, please comma separate list IDs (e.g. 123abc, 456xyz, 789def)'
        end
      end
    end
    export do
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
      field :open_house
      field :website_url
      field :services_list
      field :facebook_url
      field :twitter_url
      field :instagram_url
      field :yelp_url
    end
  end

  config.model 'Msa' do
    label 'MSA'
    label_plural 'MSAs'
  end

  config.model 'MySolaImage' do
    visible do
      bindings[:controller]._current_user.franchisee != true
    end
    list do 
      scopes [:completed]
      field :name
      field :instagram_handle
      #field :statement_text
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

  config.model 'PartnerInquiry' do
    label 'Partner Inquiry'
    label_plural 'Partner Inquiries'
  end

  config.model 'RequestTourInquiry' do
    label 'Contact Inquiry'
    label_plural 'Contact Inquiries'
    export do
      field :location_name do
        label 'Location'
      end
      field :name
      field :email
      field :phone
      field :message
      field :request_url do
        label 'Request URL'
      end
      field :created_at
    end
  end

  config.model 'Stylist' do
    label 'Salon Professional'
    label_plural 'Salon Professionals' 
    list do
      field :name
      field :url_name do
        label 'URL Name'
      end
      field :email_address
      field :location_name do
        label 'Location'
      end
      field :business_name
      field :studio_number
    end
    show do
      group :general do
        #field :legacy_id
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
        field :status
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
      end
      group :services do
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
        # field :sola_genius_enabled do
        #   help 'If set to "Yes", the stylist will be able to acess Sola Genius from within the Sola Pro app.'
        # end
        field :has_sola_pro_login do
          label 'Has Sola Pro account'
          help 'If set to "Yes", the stylist has a Sola Pro account.'
        end
        field :has_sola_genius_account do
          label 'Has SolaGenius account'
          help 'If set to "Yes", the stylist has a SolaGenius account.'
        end
        field :sola_pro_platform do
          help 'The platform (e.g. iOS or Android) the stylist is using to access Sola Pro.'
        end
        field :sola_pro_version do
          help 'The version of the Sola Pro app the stylist is using.'
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
      group :general do
        field :name
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
          # visible do
          #   bindings[:controller]._current_user.franchisee != true
          # end
        end
        field :biography, :ck_editor
        field :status
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
          associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
          associated_collection_scope do
            # bindings[:object] & bindings[:controller] are available, but not in scope's block!
            admin = bindings[:controller]._current_user
            Proc.new { |scope|
              # scoping all Players currently, let's limit them to the team's league
              # Be sure to limit if there are a lot of Players and order them by position
              if (admin.franchisee == true)
                scope = scope.where(:admin_id => admin.id)
              end
            }
          end
        end
        field :business_name
        field :studio_number
        field :work_hours
        field :accepting_new_clients        
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
      end
      group :services do
        active false
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
          html_attributes do
           {:maxlength => 18}
          end
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
      # group :credentials do
      #   active false
      #   field :password
      #   field :password_confirmation
      # end
    end
    export do
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
      # field :location_id do
      #   label 'Location'
      #   export_value do 
      #     Location.find_by(:id => value).name
      #   end
      #   pretty_value do 
      #     Location.find_by(:id => value).name
      #   end
      # end
      field :location_name
      field :business_name
      field :studio_number
      field :work_hours
      field :accepting_new_clients     
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
      field :brows
      field :facebook_url
      field :google_plus_url
      field :instagram_url
      field :pinterest_url
      field :twitter_url
      field :yelp_url
    end
  end

  config.model 'StylistMessage' do
    label 'Stylist Message'
    label_plural 'Stylist Messages'
  end

  config.model 'Testimonial' do
    visible false
  end

  config.model 'UpdateMySolaWebsite' do
    visible false

    edit do
      group :general do
        field :name do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :biography, :ck_editor do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end
      group :contact do
        field :phone_number do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :email_address do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end   
      group :business do
        field :business_name do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :work_hours do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end
      group :website do
        field :website_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :booking_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end
      group :social do
        field :facebook_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :google_plus_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :instagram_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :linkedin_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :pinterest_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :twitter_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :yelp_url do
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end
      group :services do
        field :brows do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :hair do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :hair_extensions do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :laser_hair_removal do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :eyelash_extensions do
          label 'Lashes'
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end 
        field :makeup do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :massage do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :nails do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :permanent_makeup do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :skin do
          label 'Skincare'
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :tanning do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :teeth_whitening do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :threading do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :waxing do
          # render do
          #   if value
          #     "<span style='font-size:21px;position:relative;top:3px;'>&#10004;</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
        field :other_service do
          label 'Other'
          help ' '
          # render do 
          #   if value && value.present?
          #     "<span style='position:relative;top:5px;'>#{value}</span>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>No</em>".html_safe
          #   end
          # end
        end
      end
      group :testimonials do
        field :testimonial_1 do
          label 'Testimonial #1'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_2 do
          label 'Testimonial #2'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_3 do
          label 'Testimonial #3'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_4 do
          label 'Testimonial #4'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_5 do
          label 'Testimonial #5'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_6 do
          label 'Testimonial #6'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_7 do
          label 'Testimonial #7'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_8 do
          label 'Testimonial #8'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_9 do
          label 'Testimonial #9'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
        field :testimonial_10 do
          label 'Testimonial #10'
          help ''
          # render do
          #   if value && value.present? && value.text.present?
          #     "<div style='position:relative;top:5px;margin-bottom:15px;'><div style='margin-bottom:5px'>Title: #{value.name}</div><div style='margin-bottom:5px'>Comments: #{value.text}</div><div>Region: #{value.region}</div></div>".html_safe
          #   else
          #     "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
          #   end
          # end
        end
      end
      group :images do
        field :image_1 do 
          label 'Image #1'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_2 do 
          label 'Image #2'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_3 do 
          label 'Image #3'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_4 do 
          label 'Image #4'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_5 do 
          label 'Image #5'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_6 do 
          label 'Image #6'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_7 do 
          label 'Image #7'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_8 do 
          label 'Image #8'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_9 do 
          label 'Image #9'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
        field :image_10 do 
          label 'Image #10'
          help ' '
          render do
            if value && value.present?
              "<a href='#{value.url(:carousel)}' target='_blank'><img src='#{value.url(:carousel)}' style='max-width:100%;height:auto;' /></a>".html_safe
            else
              "<em style='position:relative;top:5px;color:#AFAFAF'>None</em>".html_safe
            end
          end
        end
      end
      field :approved 
    end
  end

  config.model 'Visit' do
    visible false
  end

end