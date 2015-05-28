class ForgotPasswordController < ApplicationController
  def form
    if request.post?
      admin = Admin.where(:email => params[:username]).first
      @error = 'Unable to find an administrator with that username' unless admin
      @success = "Success! We sent a forgot password email to #{admin.email_address}. Please check your inbox for this email containing instructions on resetting your password." if admin
    end
  end

  def reset
  end
end
