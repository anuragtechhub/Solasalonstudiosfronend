# frozen_string_literal: true

module Pro
  class Api::V3::RegistrationsController < Api::V3::ApiController
    skip_before_action :authorize_user_from_token!, only: [:create]

    def create
      # currently we allow to sign up (setup password) only for users already created by admin
      find_user
      if @user&.encrypted_password.present?
        render json: { errors: [t(:email_address_already_exists)] }, status: :unprocessable_entity
      elsif @user.blank?
        render json: { errors: [t(:could_not_find_sola_professional)] }, status: :unprocessable_entity
      else
        @user.update!(update_params)
        user_sign_in(@user)
      end
    end

    private

      def find_user
        @user = Stylist.find_by(email_address: params[:registration][:email_address])
      end

      def update_params
        params.require(:registration)
          .permit(:email_address, :password, :password_confirmation).tap do |permitted|
          permitted.delete(:email_address)
        end
      end
  end
end
