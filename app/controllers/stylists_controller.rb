class StylistsController < PublicWebsiteController
  def index
  end

  def show
    @stylist = Stylist.find_by(:url_name => params[:url_name])
    @location = @stylist.location if @stylist
    if @location
      @lat = @location.latitude
      @lng = @location.longitude
      @zoom = 14
      @locations = [@location]
    end
    redirect_to :home unless @stylist
  end

  def send_a_message
    
  end
end
