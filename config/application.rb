require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

ENV['RAILS_ADMIN_THEME'] = 'custom'

module Solasalonstudios
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.serve_static_assets = true
    config.assets.digest = true
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'images')
    config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js']

    config.paperclip_defaults = {:storage => :s3, :s3_credentials => {:bucket => 'solasalonstudios', :access_key_id => 'AKIAJAKSXVOSIU7IYOTA', :secret_access_key => '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'}}
  end
end
