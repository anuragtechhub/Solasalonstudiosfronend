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

  config.model 'Location' do  
    list do
      field :name
      field :url_name
      field :address_1
      field :address_2
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
        field :description
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
        field :floorplan_image
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
        field :floorplan_image
      end
      group :extras do
        field :facebook_url
        field :twitter_url
        field :chat_code
      end
    end
  end

end