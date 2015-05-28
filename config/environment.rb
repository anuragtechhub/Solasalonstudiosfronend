# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Solasalonstudios::Application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => 'app32757554@heroku.com',
  :password => '0lv3i0042934',
  :domain => 'getmotigo.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}