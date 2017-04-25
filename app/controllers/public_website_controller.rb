class PublicWebsiteController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'public_website'

  before_action :set_locale#, :auth_if_canada

  #http_basic_authenticate_with :name => "ohcanada", :password => "tragicallyhip", :if => 

  # def auth_if_canada
  #   if I18n.locale != :en
  #     authenticate_or_request_with_http_basic 'canada' do |name, password|
  #       name == 'ocanada' && password == 'trudeau'
  #     end
  #   end
  # end

  def set_locale
    if request.domain != 'solasalonstudios.ca'
      I18n.locale = 'en-CA' 
    else
      I18n.locale = 'en'
    end
  end
end
