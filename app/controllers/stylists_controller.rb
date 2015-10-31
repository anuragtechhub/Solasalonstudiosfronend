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
    redirect_to :salon_professionals unless @stylist && @location
  end

  def send_a_message
    if request.post?
      if params[:name] && params[:name].present? && params[:email] && params[:email].present?
        msg = StylistMessage.create(:name => params[:name], :email => params[:email], :phone => params[:phone], :message => params[:message], :stylist_id => params[:stylist_id])
        msg.visit = save_visit
        msg.save
        render :json => {:success => 'Thank you for your message!'}
      else
        render :json => {:error => 'Please enter your name and email address'}
      end
    end
  end

  def redirect
    @stylist = Stylist.find_by(:url_name => params[:url_name])
    @location = @stylist.location if (@stylist && @stylist.location)
    if @stylist && @location
      redirect_to show_salon_professional_path(@stylist).gsub(/\./, '')
    else
      redirect_to :salon_professionals
    end
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
end
