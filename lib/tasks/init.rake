# frozen_string_literal: true

namespace :init do
  task clean_address_emails: :environment do |_task, _args|
    Location.find_each do |address|
      address.update!(
        email_address_for_hubspot:   nil,
        email_address_for_reports:   nil,
        email_address_for_inquiries: nil
      )
    end
  end
end
