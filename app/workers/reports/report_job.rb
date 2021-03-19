require 'google/apis/analyticsreporting_v4'
require 'render_anywhere'
require 'openssl'
require 'uri'

module Reports
  class ReportJob
    include Sidekiq::Worker

    sidekiq_options(
      queue: :reports,
      retry: 5,
      unique: :until_executed,
      unique_expiration: 3.days,
      backtrace: true
    )

    GA_IDS = {
      'US' => '81802112',
      'CA' => '137712009',
      'SOLAPRO' => '257267659'
    }
    URLS = {
      'US' => 'solasalonstudios.com',
      'CA' => 'solasalonstudios.ca'
    }
  end
end
