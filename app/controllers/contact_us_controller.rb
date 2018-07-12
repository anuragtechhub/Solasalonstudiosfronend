class ContactUsController < PublicWebsiteController

  # Newsletter USA - 09d9824082
  # Newsletter Canada - 82a3e6ea74
  
  skip_before_filter :verify_authenticity_token, :only => [:franchising_request, :request_a_tour]

  def index
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')
    end

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first    
  end

  def thank_you
    if I18n.locale == :en
      @all_locations = Location.where(:status => 'open').where(:country => 'US')
    else
      @all_locations = Location.where(:status => 'open').where(:country => 'CA')
    end

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first 
    @thank_you = true

    render :index
  end

  def franchising_request
    if request.post?
      #captcha_verified = verify_recaptcha
      if params[:name].present? && params[:email].present? && is_valid_email?(params[:email]) && params[:phone].present? #&& captcha_verified
        fr = FranchisingRequest.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :market => params[:market], :message => params[:message], :request_url => params[:request_url], :request_type => params[:request_type])
        fr.visit = save_visit
        fr.save
        if params[:email]
          gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
        end
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        #if captcha_verified
          render :json => {:error => 'Please enter your name, a valid email address and phone number'}
        #else
        #  render :json => {:error => 'No robots allowed. Please check the box to prove you are a human.'}
        #end
      end
    else
      redirect_to :contact_us
    end
  rescue Gibbon::MailChimpError => e
    render :json => {:success => 'Thank you! We will get in touch soon'}
  end

  def request_a_tour
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present? && is_valid_email?(params[:email]) && params[:phone].present?
        rti = RequestTourInquiry.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :location_id => params[:location_id], :message => params[:message], :request_url => params[:request_url])
        rti.visit = save_visit
        rti.save
        if params[:email]
          gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
          if I18n.locale && I18n.locale.to_s == 'en-CA'
            # Canada
            if params[:receive_newsletter]
              # yes, opted to receive
              gb.lists.subscribe({:id => '82a3e6ea74', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
            else
              # opted to not receive
            end
          else
            # USA
            gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
          end
        end
        if params[:message]
          # if there's a message, this is a general contact us submission
          render :json => {:success => 'Thank you! We will get in touch soon'}
        else
          render :json => {:success => 'Thank you! We will get in touch soon'}
        end
      else
        render :json => {:error => 'Please enter your name, a valid email address and phone number'}
      end
    else
      redirect_to :contact_us
    end
  rescue Gibbon::MailChimpError => e
    render :json => {:success => 'Thank you! We will get in touch soon'}
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
      redirect_to :contact_us
    end
  rescue Gibbon::MailChimpError => e
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

end
