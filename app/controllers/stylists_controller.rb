class StylistsController < PublicWebsiteController

  skip_before_filter :verify_authenticity_token, :only => :send_a_message

  def index
  end

  def show
    @stylist = Stylist.find_by(:url_name => params[:url_name])
    @location = @stylist.location if (@stylist && @stylist.location)
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    end
    #redirect_to :home unless @stylist && @location
  end

  def send_a_message
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present?
        StylistMessage.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :message => params[:message], :stylist_id => params[:stylist_id])
        render :json => {:success => 'Thank you for your message!'}
      else
        render :json => {:error => 'Please enter your name and email address'}
      end
    end
  end
end
