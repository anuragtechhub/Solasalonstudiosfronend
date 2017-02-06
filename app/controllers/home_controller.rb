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

end
