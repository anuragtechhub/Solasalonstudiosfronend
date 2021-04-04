module Callfire
  class MainJob
    include Sidekiq::Worker

    sidekiq_options(
      queue: :callfire,
      retry: 3,
      unique: :until_executed,
      unique_expiration: 3.days,
      backtrace: true
    )

    private

    def http_client
      @http ||= (
        http = Net::HTTP.new('www.callfire.com', 443)
        http.use_ssl = true
        http
      )
    end
  end
end
