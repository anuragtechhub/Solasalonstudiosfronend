class ContactUsController < PublicWebsiteController
  
  skip_before_filter :verify_authenticity_token, :only => [:franchising_request, :request_a_tour]

  def index
    @all_locations = Location.where(:status => 'open')

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first    
  end

  def franchising_request
    if request.post?
      captcha_verified = verify_recaptcha
      if params[:name].present? && params[:email].present? && is_valid_email?(params[:email]) && params[:phone].present? && captcha_verified
        fr = FranchisingRequest.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :market => params[:market], :message => params[:message], :request_url => params[:request_url])
        fr.visit = save_visit
        fr.save
        if params[:email]
          gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
        end
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        if captcha_verified
          render :json => {:error => 'Please enter your name, a valid email address and phone number'}
        else
          render :json => {:error => 'No robots allowed. Please check the box to prove you are a human.'}
        end
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
          gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
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
