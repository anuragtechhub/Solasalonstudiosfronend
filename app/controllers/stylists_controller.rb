class StylistsController < PublicWebsiteController
  def index
  end

  def show
    @stylist = Stylist.find_by(:url_name => params[:url_name])
    @location = @stylist.location if @stylist
    redirect_to :home unless @stylist
  end
end
