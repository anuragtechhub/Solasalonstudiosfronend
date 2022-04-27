# frozen_string_literal: true

module Mailchimp
  class FranchiseJob
    include Sidekiq::Worker

    sidekiq_options(
      queue:             :mailchimp,
      retry:             3,
      unique:            :until_executed,
      unique_expiration: 3.days,
      backtrace:         true
    )

    def perform(admin_id)
      admin = Admin.find(admin_id)
      gb = Gibbon::API.new(admin.mailchimp_api_key)

      admin.locations.with_mailchimp_list_ids.find_each do |location|
        if location.stylists.exists?
          batch = location.stylists.where.not(email_address: nil).map { |s| { email: { email: s.email_address } } }
          location.mailchimp_list_ids.split(',').each do |list_id|
            gb.lists.batch_subscribe(id: list_id.strip, batch: batch, double_optin: false, update_existing: true)
          end
        end
      end
    end
  end
end
