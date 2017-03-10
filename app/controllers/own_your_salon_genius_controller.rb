class OwnYourSalonGeniusController < PublicWebsiteController
  
  before_filter :authenticate

  def index

  end

  private

  def authenticate
    authenticate_or_request_with_http_basic 'solagenius' do |name, password|
      name == 'sola' && password == 'genius'
    end
  end

end