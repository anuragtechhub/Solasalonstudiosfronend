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

  def google_verification
    render '/home/google575b4ff16cfb013a.html', :layout => false
  end

  def bing_verification
    render '/home/BingSiteAuth.xml', :layout => false, :content_type => 'text/xml'
  end

  def sitemap
    send_data '/public/sitemap.xml.gz'#, :layout => false, :content_type => 'application/x-gzip'
  end

end
