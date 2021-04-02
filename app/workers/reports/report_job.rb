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

    # The current retry count and exception is yielded. The return value of the
    # block must be an integer. It is used as the delay, in seconds. A return value
    # of nil will use the default.
    sidekiq_retry_in do |count, exception|
      case exception
      when Google::Apis::RateLimitError
        60 * 60 * 24
        #10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
      end
    end
  end
end
