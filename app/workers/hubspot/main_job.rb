module Hubspot
  class MainJob
    include Sidekiq::Worker

    sidekiq_options(
      queue: :hubspot,
      retry: 3,
      unique: :until_executed,
      unique_expiration: 3.days,
      backtrace: true
    )

    private

    def get_hubspot_owner_id(object)
      email_address = if object.location.present?
        if object.location.email_address_for_hubspot.present?
          object.location.email_address_for_hubspot
        else
          object.location.email_address_for_inquiries
        end
      end
      return nil if email_address.blank?

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])
      Hubspot::Owner.all&.find{|o| o.email == email_address}&.owner_id
    end
  end
end
