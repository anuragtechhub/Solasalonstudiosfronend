class HomeController < PublicWebsiteController
  
  def index
    # if Thread.current[:current_admin] 
    #   redirect_to :rails_admin
    # end
    # if I18n.locale.to_s == 'en'
    #   render 'index_en'
    # else 
    #   render 'index_en_ca'
    # end
  end

  def five_thousand
  end

  def franchising
    redirect_to 'https://pages.solasalonstudios.com/signup?utm_campaign=fran_dev&utm_source=referral&utm_medium=website'
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
    # data = open("https://s3.amazonaws.com/solasitemap/sitemaps/sitemap.xml")
    # send_data data.read, :type => data.
    redirect_to 'https://s3.amazonaws.com/solasitemap/sitemaps/sitemap.xml'
  end
  
end
