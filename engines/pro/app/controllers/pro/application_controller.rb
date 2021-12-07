module Pro
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def get_user(email=nil, user_only: false)
      return if email.blank?

      Stylist.open.order(:id).find_by(email_address: email) ||
        (!user_only && Admin.where('email = :email or email_address = :email', email: email).order(:id).first).presence
    end
  end
end
