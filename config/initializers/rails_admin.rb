RailsAdmin.config do |config|
  
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  # config.audit_with :paper_trail, 'Admin', 'PaperTrail::Version'

  # config.excluded_models << 'GetFeatured'
  # config.excluded_models << 'ResetPassword'
  # config.excluded_models << 'ExpressionEngine'

  config.model 'Admin' do
    #label 'Administrator'
    #label_plural 'Administrators'    
    list do
      field :email
      field :sign_in_count
      field :last_sign_in_at
    end
    show do
      field :email
      field :sign_in_count
      field :last_sign_in_at      
    end
    edit do
      field :email
      field :password
      field :password_confirmation     
    end
  end

  config.model 'Article' do
    list do
      field :title
      field :url_title
      field :summary do
        pretty_value do
          value.html_safe
        end
      end
      field :created_at
    end 
    show do
      field :title
      field :url_title
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
      field :extended_text do
        pretty_value do
          value.html_safe
        end
      end
      field :image do 
        pretty_value do 
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
        end
      end
    end 
    edit do
      field :title
      field :url_title
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
      field :extended_text do
        pretty_value do
          value.html_safe
        end
      end
      field :image do 
        pretty_value do 
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
        end
      end
    end 
  end

  config.model 'Blog' do
    list do
      field :title
      field :url_title
      field :summary do
        pretty_value do
          value.html_safe
        end
      end
      field :author do
        pretty_value do
          value.html_safe
        end
      end
      field :created_at
    end
    show do
      field :title
      field :url_title do
        label 'URL Title'
      end
      field :image do 
        pretty_value do 
          "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
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
    end
    edit do
      field :title
      field :url_title do
        label 'URL Title'
      end
      field :image
      field :summary
      field :body
      field :author
    end
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
      field :postal_code
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
        field :status
      end
      group :contact do
        field :general_contact_name do
          label 'General Contact Name'
        end
        field :email_address_for_inquiries do
          label 'Email Address for Inquiries'
        end
        field :phone_number
      end
      group :address do
        field :address_1
        field :address_2
        field :city
        field :state
        field :postal_code
        field :latitude
        field :longitude
      end
      group :images do
        field :floorplan_image do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_11 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_12 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_13 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_14 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_15 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_16 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_17 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_18 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_19 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_20 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
      end
      group :extras do
        field :facebook_url
        field :twitter_url
        field :chat_code
      end
    end
    edit do
      group :general do
        field :name
        field :url_name do
          label 'URL Name'
          help 'The URL name should contain only alphanumberic characters (A-Z and 0-9). No spaces or special characters are permitted. Dashes or underscores can be used to separate words (e.g. my-hair-is-awesome)'
        end
        field :description
        field :status
      end
      group :contact do
        field :general_contact_name do
          label 'General Contact Name'
        end
        field :email_address_for_inquiries do
          label 'Email Address for Inquiries'
        end
        field :phone_number
      end
      group :address do
        field :address_1
        field :address_2
        field :city
        field :state
        field :postal_code
        field :latitude do
          help 'The latitude will be automatically set when a valid address is entered. You do not need to set the latitude manually (but you can if you really want to)'
        end
        field :longitude do
          help 'The longitude will be automatically set when a valid address is entered. You do not need to set the longitude manually (but you can if you really want to)'
        end
      end
      group :images do
        field :floorplan_image do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_11 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_12 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_13 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_14 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_15 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_16 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_17 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_18 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_19 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_20 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
      end
      group :extras do
        field :facebook_url
        field :twitter_url
        field :chat_code
      end
    end
  end

  config.model 'Stylist' do
    label 'Salon Professional'
    label_plural 'Salon Professionals' 
    list do
      #filters [:name, :url_name, :email_address, :location_name, :business_name, :studio_number]
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
        field :email_address
        field :phone_number
      end      
      group :business do
        field :location
        field :business_name
        field :studio_number
        field :work_hours
        field :accepting_new_clients
        field :booking_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
      end
      group :services do
        field :hair
        field :skin
        field :nails
        field :massage
        field :teeth_whitening
        field :hair_extensions
        field :eyelash_extensions
        field :makeup
        field :tanning
        field :waxing
        field :brows
      end
      group :images do
        field :image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
        field :image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe
          end
        end
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
        end
        field :biography
        field :status
      end
      group :contact do
        field :email_address
        field :phone_number
      end      
      group :business do
        field :location
        field :business_name
        field :studio_number
        field :work_hours
        field :booking_url do
          help 'It is critical that you include the "http://" portion of the URL. If you do not have online booking, leave this blank'
        end
        field :accepting_new_clients        
      end
      group :services do
        field :hair
        field :skin
        field :nails
        field :massage
        field :teeth_whitening
        field :hair_extensions
        field :eyelash_extensions
        field :makeup
        field :tanning
        field :waxing
        field :brows
      end
      group :images do
        field :image_1 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_2 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_3 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_4 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_5 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_6 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_7 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_8 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_9 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
        field :image_10 do 
          pretty_value do 
            "<a href='#{value.url(:original)}' target='_blank'><img src='#{value.url(:thumbnail)}' /></a>".html_safe unless value.blank?
          end
        end
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
  end

  config.model 'Testimonial' do
    visible false
  end

end