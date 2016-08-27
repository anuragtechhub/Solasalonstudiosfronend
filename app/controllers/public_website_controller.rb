class PublicWebsiteController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'public_website'

  before_action :set_locale

  def set_locale
    if request.domain == 'solasalonstudios.ca'
      I18n.locale = 'en-CA' 
    else
      I18n.locale = 'en'
    end
  end
end
