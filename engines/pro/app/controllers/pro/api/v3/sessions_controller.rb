module Pro
  class Api::V3::SessionsController < Api::V3::ApiController
    skip_before_action :authorize_user_from_token!, only: [:create]

    def create
      user_email_sign_in(create_params)
    end

    private

    def user_email_sign_in(options)
      user = find_user(options)

      if user.blank? || !valid_password?(user, options[:password])
        render status: 401, json: { errors: [t(:invalid_email_or_password)] }
      else
        user_sign_in(user)
      end
    end

    def valid_password?(user, password)
      return true if ENV['TEST_MODE'].to_s == 'true' && password == ENV['TEST_PASSWORD'].to_s

      user.valid_password?(password)
    end

    def create_params
      params.require(:session).permit([:email, :password])
    end

    def find_user(options)
      Stylist.where(status: 'open').find_for_authentication(email_address: options[:email]) ||
        Admin.find_for_authentication(email_address: options[:email]) ||
        Admin.find_for_authentication(email: options[:email])
    end
  end
end