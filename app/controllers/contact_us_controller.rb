class ContactUsController < PublicWebsiteController

  # Newsletter USA - 09d9824082
  # Newsletter Canada - 82a3e6ea74

  skip_before_filter :verify_authenticity_token, :only => [:franchising_request, :request_a_tour]

  def index
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    elsif I18n.locale.to_s == 'en-CA'
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')
    elsif I18n.locale.to_s == 'pt-BR'
      @all_locations = Location.where(:status => 'open').where(:country => 'BR')
    end

    #@last_location = Location.order(:updated_at => :desc).first
    #@last_msa = Msa.order(:updated_at => :desc).first
    @success_redirect_url = contact_us_contact_form_success_path

    if I18n.locale.to_s == 'pt-BR'
      render 'index_br'
    end
  end

  def contact_form_success
    @success_redirect_url = contact_us_contact_form_success_path
    @contact_form_success = true
    @scroll_top = params[:s_t]
    @success = 'Thank you! We will get in touch soon'
    render 'index'
  end

  def thank_you
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    elsif I18n.locale.to_s == 'en-CA'
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')
    elsif I18n.locale.to_s == 'pt-BR'
      @all_locations = Location.where(:status => 'open').where(:country => 'BR')
    end

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first
    @thank_you = true

    render :index
  end

  def franchising_request
    # if request.post?
    #   #captcha_verified = verify_recaptcha
    #   if params[:name].present? && params[:email].present? && is_valid_email?(params[:email]) && params[:phone].present? #&& captcha_verified
    #     fr = FranchisingRequest.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :market => params[:market], :message => params[:message], :request_url => params[:request_url], :request_type => params[:request_type])
    #     fr.visit = save_visit
    #     fr.save
    #     if params[:email]
    #       gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
    #       gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
    #     end
    #     render :json => {:success => 'Thank you! We will get in touch soon'}
    #   else
    #     #if captcha_verified
    #       render :json => {:error => 'Please enter your name, a valid email address and phone number'}
    #     #else
    #     #  render :json => {:error => 'No robots allowed. Please check the box to prove you are a human.'}
    #     #end
    #   end
    # else
    #   redirect_to :contact_us, :status => 301
    # end
  rescue Gibbon::MailChimpError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    render :json => {:success => 'Thank you! We will get in touch soon'}
  end

  def request_a_tour
    if request.post?
      if params[:required_fields].present?
        all_good = true
        #p "required_fields=#{params[:required_fields]}"
        params[:required_fields].each do |required_field|
          #p "required_field=#{required_field},#{params[required_field].present?}"
          if required_field == 'email' && params[required_field].present? && is_valid_email?(params[required_field])
            # all good
          elsif params[required_field] && params[required_field].present?
            # all good
          else
            all_good = false
            break
          end
        end
      end

      if (params[:required_fields].present? && all_good) && (params[:name] && params[:name].present? && params[:email] && params[:email].present? && is_valid_email?(params[:email])) #&& params[:message].present? && params[:contact_preference].present?
        #p "BOUT TO CHECK"
        if params[:required_fields].blank? && params[:dont_see_your_location].to_s == "true" && !is_valid_zip_code?(params[:zip_code])
          render :json => {:error => 'Please enter your zip code'}
        else
          unless verify_recaptcha(response: params[:recaptcha_token], private_key: ENV['RECAPTCHA_SECRET_KEY'])
            render :json => {:error => 'Captcha is wrong!'}
          else
            unless banned_ip_addresses.include? request.remote_ip
              # if params[:state].blank? && params[:zip_code].present?
              #   json = ZipCodes.identify(params[:zip_code])
              #   if json && json[:state_name]
              #     params[:state] = json[:state_name]
              #   end
              # end


              rti = RequestTourInquiry.new({
                :name => params[:name],
                :email => params[:email],
                :phone => params[:phone],
                :canada_locations => params[:canada_locations],
                :location_id => params[:location_id],
                :message => params[:message],
                :newsletter => params[:newsletter],
                :request_url => params[:request_url],
                :contact_preference => params[:contact_preference],
                :how_can_we_help_you => params[:how_can_we_help_you],
                :i_would_like_to_be_contacted => params[:i_would_like_to_be_contacted],
                :dont_see_your_location => params[:dont_see_your_location],
                :zip_code => params[:zip_code],
                :state => params[:state],
                :services => params[:services],
                :send_email_to_prospect => params[:send_email_to_prospect],
                :source => params[:source],
                :campaign => params[:campaign],
                :content => params[:content],
                :medium => params[:medium],
                :hutk => params[:hutk],
              })
              rti.visit = save_visit
              rti.save


              # if params[:is_sola_professional] == 'yes' && params[:send_email_to_prospect] == 'financial_guide'
              #   p "send prospect the financial guide email!"
              #   email = PublicWebsiteMailer.financial_guide(rti)
              #   email.deliver if email
              # else
              #   rti.visit = save_visit
              #   rti.save
              # end


              # if params[:i_would_like_to_be_contacted] == true && params[:send_email_to_prospect] == 'financial_guide'
              #   p "send prospect the financial guide email!"
              #   email = PublicWebsiteMailer.financial_guide(rti)
              #   email.deliver if email
              # else
              #   rti.visit = save_visit
              #   rti.save
              # end


              # if params[:email]
              #   gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
              #   if I18n.locale && I18n.locale.to_s == 'en-CA'
              #     # Canada
              #     if params[:receive_newsletter]
              #       # yes, opted to receive
              #       gb.lists.subscribe({:id => '82a3e6ea74', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
              #     else
              #       # opted to not receive
              #     end
              #   else
              #     # USA
              #     gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
              #   end
              # end
            end
            @success = 'Thank you! We will get in touch soon'
            if rti && rti.send_email_to_prospect == 'modern_salon_2019_05'
              @success = 'Thank you for downloading our free guide! Please check your email.'
            end
            if params[:message]
              # if there's a message, this is a general contact us submission
              render :json => {:success => @success}
            else
              render :json => {:success => @success}
            end
          end
        end
      else
        #p "something is invalid"
        if params[:required_fields].present?
          render :json => {:error => "Please enter your #{params[:required_fields].to_sentence.gsub(/how_can_we_help_you/, 'select an option from the "I would like to" section').gsub(/is_sola_professional/, 'select whether you are a Sola professional')}"}
        elsif params[:dont_see_your_location].to_s == "true" && !is_valid_zip_code?(params[:zip_code])
          p "params[:dont_see_your_location]=#{params[:dont_see_your_location]}"
          p "is_valid_zip_code?(params[:zip_code])=#{is_valid_zip_code?(params[:zip_code])}"
          render :json => {:error => 'Please enter your zip code, name and a valid email address'}
        else
          render :json => {:error => 'Please enter your name and a valid email address'}
        end
      end
    else
      redirect_to :contact_us, :status => 301
    end
  rescue Gibbon::MailChimpError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    @success = 'Thank you! We will get in touch soon'
    if rti && rti.send_email_to_prospect == 'modern_salon_2019_05'
      @success = 'Thank you for downloading our free guide! Please check your email.'
    end
    render :json => {:success => @success}
  end

  # don't think this is used anymore (was for Sola 5000 page)
  def partner_inquiry
    if request.post?
      if params[:name].present? && params[:email].present? && is_valid_email?(params[:email]) && params[:phone].present?
        pi = PartnerInquiry.create(:subject => params[:subject], :name => params[:name], :email => params[:email], :phone => params[:phone], :company_name => params[:company_name], :message => params[:message], :request_url => params[:request_url])
        pi.visit = save_visit
        pi.save
        if params[:email]
          gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
        end
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        render :json => {:error => 'Please enter your name, a valid email address and phone number'}
      end
    else
      redirect_to :contact_us, :status => 301
    end
  rescue Gibbon::MailChimpError => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    render :json => {:success => 'Thank you! We will get in touch soon'}
  end

  private

  def save_visit
    visit = Visit.new

    visit.uuid = request.uuid
    visit.ip_address = request.remote_ip
    visit.user_agent_string = request.env['HTTP_USER_AGENT']

    if visit.save
      return visit
    else
      return nil
    end
  end

  def is_valid_email?(email = '')
    email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def is_valid_zip_code?(zip_code = '')
    zip_code =~ /^\d{5}(-\d{4})?$/
  end

end
