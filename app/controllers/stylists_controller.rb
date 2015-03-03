class StylistsController < PublicWebsiteController
  def index
  end

  def show
    p "url_name=#{params[:url_name]}"
    @stylist = Stylist.find_by(:url_name => params[:url_name])
    redirect_to :home unless @stylist
  end
end
