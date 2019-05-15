class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  before_filter :update_my_sola_catch
  around_filter :do_with_current_admin

  def update_my_sola_catch
    if request.fullpath.end_with?('update_my_sola_website') || request.fullpath.end_with?('update_my_sola_website/')
      redirect_to 'https://www.solasalonstudios.com/admin', :flash => {:alert => "Update My Sola Website request approved successfully!"}, :status => 301
    end
  end

  def do_with_current_admin
    Thread.current[:current_admin] = self.current_admin
    begin
      yield
    ensure
      Thread.current[:current_admin] = nil
    end      
  end

  def self.get_asset(name)
    if Rails.application.assets
      asse = Rails.application.assets[name]
      return asse.to_s if asse 
    end
    asse = Rails.application.assets_manifest.assets[name]
    return nil unless asse
    return File.binread(File.join(Rails.application.assets_manifest.dir, asse))
  end

end