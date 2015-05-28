class ForgotPasswordController < ApplicationController
  def form
    if request.post?
      admin = Admin.where(:email => params[:username]).first
      @error = 'Unable to find an administrator with that username' unless admin

      if admin && admin.forgot_password
        @success = "Success! We sent a forgot password email to #{admin.email_address}"
      else
        @error = 'There was a problem processing your forgot password request. Please try again. If the problem persists, please contact support'
      end
    end
  end

  def reset
  end
end
