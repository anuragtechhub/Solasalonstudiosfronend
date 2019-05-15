class ForgotPasswordController < ApplicationController
  def form
    if flash[:error]
      @error = flash[:error];
      flash[:error] = nil;
    end

    if request.post?
      admin = Admin.where('lower(email) = ?', params[:username].downcase.strip).first#Admin.where(:email => params[:username]).first
      
      if params[:username].blank? and admin.blank?
        @error = 'Please enter a username'
      elsif admin.blank?
        @error = "We are unable to find an administrator with the username '#{params[:username]}'"
      else
        if admin && admin.forgot_password
          @success = "Success! We sent a forgot password email to #{admin.email_address}"
          params[:username] = ''
        else
          @error = 'There was a problem processing your forgot password request. Please try again. If the problem persists, please contact support'
        end
      end
    end
  end

  def reset
    admin = Admin.where(:email => params[:username], :forgot_password_key => params[:key]).first
    if admin
      if request.post?
        if params[:password].blank? || params[:password_confirmation].blank?
          @error = 'Please fill out both the new password and new password confirmation fields'
        elsif params[:password] != params[:password_confirmation]
          @error = 'The passwords you entered do not match'
        else
          admin.password = params[:password]
          admin.password_confirmation = params[:password_confirmation]
          admin.forgot_password_key = nil
          if admin.save
            @success = "Your password is updated!<br><br>We will automatically redirect you to the login screen in 10 seconds or #{view_context.link_to 'click here to login now', :rails_admin} <script>setTimeout(function () { window.location = '/admin'; }, 10000);</script>"
          else
            @error = 'There was a problem updating your password. Please try again. If the problem persists, please contact support'
          end
        end
      end
    else
      redirect_to :forgot_password_form, :flash => { :error => "The time alloted to reset your password has expired. Please make a new forgot password request" }, :status => 301
    end
  end
end
