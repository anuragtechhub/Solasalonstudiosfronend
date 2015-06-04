class ContactUsController < PublicWebsiteController
  
  skip_before_filter :verify_authenticity_token, :only => [:franchising_request, :request_a_tour]

  def index
    @all_locations = Location.where(:status => 'open')

    @last_location = Location.order(:updated_at => :desc).first
    @last_msa = Msa.order(:updated_at => :desc).first    
  end

  def franchising_request
    if request.post?
      if params[:name].present? && ((params[:email].present? && is_valid_email?(params[:email])) || params[:phone].present?)
        FranchisingRequest.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :market => params[:market], :message => params[:message])
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        render :json => {:error => 'Please enter your name and a valid email address or phone number'}
      end
    end
  end

  def request_a_tour
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present? && is_valid_email?(params[:email])
        RequestTourInquiry.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :location_id => params[:location_id], :message => params[:message])
        
        if params[:message]
          # if there's a message, this is a general contact us submission
          render :json => {:success => 'Thank you! We will get in touch soon'}
        else
          render :json => {:success => 'Thank you! We will get in touch soon'}
        end
      else
        render :json => {:error => 'Please enter your name and a valid email address'}
      end
    end
  end

  def partner_inquiry
    if request.post?
      if params[:name].present? && ((params[:email].present? && is_valid_email?(params[:email])) || params[:phone].present?)
        PartnerInquiry.create(:subject => params[:subject], :name => params[:name], :email => params[:email], :phone => params[:phone], :company_name => params[:company_name], :message => params[:message])
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        render :json => {:error => 'Please enter your name and a valid email address or phone number'}
      end
    end
  end

  private

  def is_valid_email?(email = '')
    email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

end
