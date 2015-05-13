class ContactUsController < PublicWebsiteController
  
  def index
    @all_locations = Location.all
  end

  def franchising_request
    if request.post?
      if params[:name].present? && (params[:email].present? || params[:phone].present?)
        FranchisingRequest.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :market => params[:market], :message => params[:message])
        render :json => {:success => 'Thank you! We will get in touch soon'}
      else
        render :json => {:error => 'Please enter your name and email address or phone number'}
      end
    end
  end

  def request_a_tour
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present?
        RequestTourInquiry.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :location_id => params[:location_id], :message => params[:message])
        
        if params[:message]
          # if there's a message, this is a general contact us submission
          render :json => {:success => 'Thank you! We will get in touch soon'}
        else
          render :json => {:success => 'Thank you! We will get in touch soon to schedule a tour'}
        end
      else
        render :json => {:error => 'Please enter your name and email address'}
      end
    end
  end

end
