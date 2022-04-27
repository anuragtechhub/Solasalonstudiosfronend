# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  around_action :do_with_current_admin

  def do_with_current_admin
    Thread.current[:current_admin] = current_admin
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

    File.binread(File.join(Rails.application.assets_manifest.dir, asse))
  end
end
