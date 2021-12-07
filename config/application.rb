require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

ENV['RAILS_ADMIN_THEME'] = 'custom'

module Solasalonstudios
  class Application < Rails::Application

    # config.action_dispatch.default_headers = {
    #   'X-Frame-Options' => 'ALLOWALL'
    # }

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{^/printing.*$}, 'https://www.conquestgraphics.com/login?ATN=SolaSalon'

      r301 %r{^/mobile.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/virtual_tour.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/welcome.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/concept.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/content.*$}, 'https://www.solasalonstudios.com/admin'
      r301 %r{^/directory.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/homepage.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/index.php/welcome.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/index.php/concept.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/index.php/directory.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/index.php/welcome.*$}, 'https://www.solasalonstudios.com/'
      r301 %r{^/index.php/gallery.*$}, 'https://www.solasalonstudios.com/'

      r301 %r{^/forums.*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/member/messages.*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/member/memberlist$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/member/profile$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/member/[0-9]*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/viewcategory/?[0-9]*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/viewforum/?[0-9]*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/viewthread/?[0-9]*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/newreply/?[0-9]*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/forums/do_search.*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/assets/?$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/operations/?$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/operations/training/?$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/operations/manual/?$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/operations/disclaimer/?$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
      r301 %r{^/resourcecenter*$}, 'http://solasalonstudios.franchisesoftwaresystems.com/index.aspx'
    end

    config.middleware.use Rack::Deflater
    config.middleware.use HtmlCompressor::Rack, {:remove_input_attributes => false, :remove_http_protocol => false, :remove_https_protocol => false}

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    I18n.config.enforce_available_locales = false
    config.i18n.default_locale = ENV['DEFAULT_LOCALE']
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]

    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.initialize_on_precompile = false

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'images', 'lib')
    config.assets.precompile += %w(.svg .eot .woff .ttf .png .jpg)
    config.assets.precompile += ['admin.css', 'rails_admin/rails_admin.css', 'rails_admin/rails_admin.js', 'rails_admin/customization.js', 'aos.js', 'aos.css', 'booknow_landing_page.css']
    config.assets.precompile += ['fullscreen_hero.js', 'ckeditor/*'] #'digital_directory.css', 'digital_directory.js',
    config.assets.precompile += ['sola_pro.js', 'in_the_news.js', 'our_studios.js', 'why_sola.js', 'search_sola.js', 'solagenius.js', 'search_salon.js']
    config.assets.precompile += ['public_website.css', 'public_website.js', 'mysola.js', 'locations.js', 'locations_ca.js', 'locations_br.js', 'locations_state_select.js',
                                 'salon_stylists.js', 'blog.js', 'contact_us.js', 'contact_us_ca.js', 'own_your_salon.js', 'salon_professionals.js',
                                 'faq.js', 'sessions.js', 'sessions_2018.js', 'wow.min.js']
    config.assets.precompile += ['bootstrap4hack.css', 'slick.js', 'slick.css', 'slick-theme.css', 'sejasola.css', 'sejasola.js', 'goingindependent.js', 'goingindependent.css']

    # franchising engine
    config.assets.precompile += %w[
      franchising/thank_you.css franchising/style.css franchising/main_page.js franchising/franchising_articles.css
    ]

    # pro engine
    config.assets.precompile += %w[
      pro/application.css pro/splash.css pro/application.js pro/splash.css
    ]

    config.paperclip_defaults = {storage: :s3, s3_credentials: {bucket: ENV['FOG_DIRECTORY'], s3_region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']}}
  end
end
