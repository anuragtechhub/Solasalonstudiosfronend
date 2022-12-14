# frozen_string_literal: true

# Load the Rails application.
require File.expand_path('application', __dir__)

# Initialize the Rails application.
Solasalonstudios::Application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name:            'apikey',
  password:             ENV.fetch('SENDGRID_API_KEY', nil),
  domain:               'solasalonstudios.com',
  address:              'smtp.sendgrid.net',
  port:                 587,
  authentication:       :plain,
  enable_starttls_auto: true
}
