# frozen_string_literal: true

module Hubspot
  class NewsletterJob < ::Hubspot::MainJob
    def perform(email, website_country)
      return if ENV['HUBSPOT_API_KEY'].blank?

      Hubspot.configure(hapikey: ENV.fetch('HUBSPOT_API_KEY', nil))
      data = {
        email:      email.to_s.strip,
        hs_persona: 'persona_5',
        country:    website_country
      }
      Hubspot::Contact.create_or_update!([data])
      HubspotLog.create(status: 'success', data: data, kind: 'news_letter', action: 'contact')
    rescue StandardError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: data, kind: 'news_letter', action: 'contact')
      raise
    end
  end
end
