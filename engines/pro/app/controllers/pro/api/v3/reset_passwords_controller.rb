module Pro
  class Api::V3::ResetPasswordsController < Api::V3::ApiController
    skip_before_action :authorize_user_from_token!, only: %i[create update]

    def create
      raise StandardError, t(:please_enter_your_email_address) if params[:email].blank?

      user = get_user(params[:email])

      # Allow to set new password
      if user.present? && user.encrypted_password.blank? && params[:password].present? && params[:password_confirmation].present?
        user.update_attributes!({
          password: params[:password],
          password_confirmation: params[:password_confirmation],
        })
        user_sign_in(user)
      elsif user.present?
        # Or send reset password instructions
        reset_password = ResetPassword.create(userable: user)
        Pro::AppMailer.forgot_password(reset_password).deliver
        render json: { success: [t(:reset_password_sent_to, { email: reset_password.email })] }
      else
        raise StandardError, t(:could_not_find_sola_professional)
      end
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render json: { errors: [e.message] }
    end

    def update
      reset_password = ResetPassword.find_by(public_id: params[:id])
      raise StandardError, t(:invalid_reset_password_token) unless reset_password
      raise StandardError, t(:reset_password_token_used) unless reset_password.date_used.nil?

      reset_password.userable.update_attributes!(update_params)
      reset_password.update_attributes!(date_used: DateTime.current)
      respond_with(reset_password.userable, location: nil)
    rescue => e
      NewRelic::Agent.notice_error(e)
      Rollbar.error(e)
      render json: { errors: [e.message] }
    end

    private

    def update_params
      params.require(:reset_password).permit(
        :password, :password_confirmation
      )
    end
  end
end
