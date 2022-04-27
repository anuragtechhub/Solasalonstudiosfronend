# frozen_string_literal: true

module RentManager
  class SyncJob
    include Sidekiq::Worker

    sidekiq_options(
      queue:             :rent_manager,
      retry:             3,
      unique:            :until_executed,
      unique_expiration: 3.days,
      backtrace:         true
    )

    def perform
      ::Rentmanager::Mapper.new.sync
    end
  end
end
