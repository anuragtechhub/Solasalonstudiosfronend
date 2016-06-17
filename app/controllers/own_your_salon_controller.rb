class OwnYourSalonController < PublicWebsiteController

  http_basic_authenticate_with :name => "sola", :password => "stylists", :only => [:new]
  
  def index
  end

  def new
  end

end