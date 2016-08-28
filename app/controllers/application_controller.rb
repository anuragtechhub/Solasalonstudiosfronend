class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  around_filter :do_with_current_admin

  def do_with_current_admin
    Thread.current[:current_admin] = self.current_admin
    begin
      yield
    ensure
      Thread.current[:current_admin] = nil
    end      
  end

end