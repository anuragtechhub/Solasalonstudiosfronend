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

    end
    show do
 
    end
    edit do
   
    end
  end

end