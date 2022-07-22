# frozen_string_literal: true

class Pro::PasswordController < Pro::ApplicationController
  skip_before_filter :authorize
  layout 'no_header'

  def forgot
    if request.post?
      raise StandardError, 'Please enter your email address' if params[:email].blank?

      stylist_user = Stylist.where(email_address: params[:email], status: 'open').first
      @admin = Admin.find_by(email: params[:email])

      deleted_user = is_deleted_user unless stylist_user || @admin

      if stylist_user
        @reset_password = ResetPassword.create userable: stylist_user
        Pro::AppMailer.forgot_password(@reset_password).deliver
        @success = "Reset password email sent to #{@reset_password.email}"
      elsif @admin
        @reset_password = ResetPassword.create userable: @admin
        Pro::AppMailer.forgot_password(@reset_password).deliver
        @success = "Reset password email sent to #{@reset_password.email}"
      elsif deleted_user
        render json: { is_deleted: deleted_user.is_deleted, message: "This Stylist is Deleted"}
      else
        raise StandardError, 'We could not find a user with that email address'
      end
    end
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    @errors = [e.message]
  end

  def reset
    @reset_password = ResetPassword.find_by(public_id: params[:id])
    raise StandardError, "Invalid reset password token.<br><br>#{view_context.link_to('Please submit a new forgot password request', :forgot_password)}".html_safe unless @reset_password
    raise StandardError, "It appears that this reset password token has already been used.<br><br>#{view_context.link_to('Please submit a new forgot password request', :forgot_password)}".html_safe unless @reset_password.date_used.nil?

    if request.post?
      raise StandardError, 'Passwords do not match' unless params[:password] == params[:password_confirmation]

      # set new password
      @reset_password.userable.password = params[:password]
      @reset_password.userable.password_confirmation = params[:password_confirmation]
      @reset_password.userable.save

      # update reset password timestamp
      @reset_password.date_used = DateTime.now
      @reset_password.save

      # clear out passwords
      params[:password] = nil
      params[:password_confirmation] = nil

      @success = 'Password changed successfully!<br>Please return to the Sola Pro app to log in.'.html_safe
    end
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
    @errors = [e.message]
  end

  private

  def is_deleted_user
    Stylist.unscoped.where(email_address: params[:email], status: 'open').first
  end
end
