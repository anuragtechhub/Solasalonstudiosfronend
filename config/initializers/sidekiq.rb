Sidekiq.options[:dead_max_jobs] = 50_000

REDIS_URL = ENV.fetch('REDISCLOUD_URL') { ENV['REDIS_URL'] }
REDIS_POOL = ConnectionPool.new(size: 15) { Redis.new(url: REDIS_URL) }
Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end
  SidekiqUniqueJobs::Server.configure(config)
end
Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq::Extensions.enable_delay!
