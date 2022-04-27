# frozen_string_literal: true

module Hubspot
  class MainJob
    include Sidekiq::Worker

    sidekiq_options(
      queue:             :hubspot,
      retry:             3,
      unique:            :until_executed,
      unique_expiration: 3.days,
      backtrace:         true
    )

    private

      def get_hubspot_owner_id(object)
        email_address = if object.location.present?
                          object.location.email_address_for_hubspot.presence || object.location.email_address_for_inquiries
                        end
        return nil if email_address.blank?

        Hubspot.configure(hapikey: ENV.fetch('HUBSPOT_API_KEY', nil))
        Hubspot::Owner.all&.find { |o| o.email == email_address.strip }&.owner_id
      end
  end
end
