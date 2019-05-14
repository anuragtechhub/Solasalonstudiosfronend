class FaqController < PublicWebsiteController
  def index
    redirect_to :home, :status => 301
  end
end
