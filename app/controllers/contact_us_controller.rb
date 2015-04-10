class ContactUsController < PublicWebsiteController
  
  def index
  end

  def request_a_tour
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present?
        RequestTourInquiry.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :location_id => params[:location_id])
        render :json => {:success => 'Thank you! We will get in touch soon to schedule a tour'}
      else
        render :json => {:error => 'Please enter your name and email address'}
      end
    end
  end

end
