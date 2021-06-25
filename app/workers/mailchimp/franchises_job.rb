module Mailchimp
  class FranchisesJob
    include Sidekiq::Worker

    sidekiq_options(
      queue: :mailchimp,
      retry: 3,
      unique: :until_executed,
      unique_expiration: 3.days,
      backtrace: true
    )

    def perform
      Admin.with_mailchimp_credentials.find_each do |admin|
        Mailchimp::FranchiseJob.perform_async(admin.id)
      end
    end
  end
end
