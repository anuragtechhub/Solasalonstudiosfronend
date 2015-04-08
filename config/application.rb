require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

ENV['RAILS_ADMIN_THEME'] = 'custom'

module Solasalonstudios
  class Application < Rails::Application
    
    config.middleware.use Rack::Deflater
    config.middleware.use HtmlCompressor::Rack, {:remove_input_attributes => false, :remove_http_protocol => false}
    
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc    

    config.serve_static_assets = true
    config.assets.digest = true
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false
    
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'images')
    config.assets.precompile += %w(.svg .eot .woff .ttf .png .jpg)  
    config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js']
    config.assets.precompile += ['digital_directory.css', 'digital_directory.js']
    config.assets.precompile += ['public_website.css', 'public_website.js', 'locations.js', 'location_state_select.js', 'salon_stylists.js']

    config.paperclip_defaults = {:storage => :s3, :s3_credentials => {:bucket => 'solasalonstudios', :access_key_id => 'AKIAJAKSXVOSIU7IYOTA', :secret_access_key => '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'}}
  end
end
