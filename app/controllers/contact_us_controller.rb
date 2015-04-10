class ContactUsController < PublicWebsiteController
  
  def index
  end

  def request_a_tour
    if request.post?
      if params[:your_name] && params[:your_name].present? && params[:email_address] && params[:email_address].present?

        render :json => {:success => 'Thank you! We will get in touch to schedule your tour soon.'}
      else
        render :json => {:error => 'Please enter your name and email address'}
      end
    end
  end

end
