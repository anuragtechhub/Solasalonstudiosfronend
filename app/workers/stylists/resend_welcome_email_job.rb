# frozen_string_literal: true

module Stylists
  class ResendWelcomeEmailJob
    include Sidekiq::Worker
    sidekiq_options(
      queue:             :default,
      retry:             1,
      unique:            :until_executed,
      unique_expiration: 3.days,
      backtrace:         true
    )
    def perform(stylist_id)
      stylist = Stylist.find_by(id: stylist_id)
      return if stylist.blank?
      return if EmailEvent.exists?(email: stylist.email_address, category: 'Welcome Email', event: 'open')

      stylist.resend_welcome_email
    end
  end
end
