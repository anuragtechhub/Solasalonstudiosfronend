class HomeController < PublicWebsiteController
  
  def index
    # if Thread.current[:current_admin] 
    #   redirect_to :rails_admin
    # end
  end

  def five_thousand
  end

  def new_cms
    render :layout => 'fullscreen'
  end

  def robots
    render '/home/robots.txt', layout: false, content_type: 'text/plain'
  end

end
