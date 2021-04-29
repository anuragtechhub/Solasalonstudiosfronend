module Hubspot
  class RequestTourJob < ::Hubspot::MainJob

    def perform(request_id)
      return if ENV['HUBSPOT_API_KEY'].blank?

      @report = RequestTourInquiry.find(request_id)
      submit_form
      create_contact
    end

    private

    def submit_form
      stylist = Stylist.find_by(email_address: @report.email)
      data = {
        email: @report.email,
        name: @report.name,
        firstname: @report.first_name,
        lastname: @report.last_name,
        phone: @report.phone,
        message: @report.message,
        request_url: @report.request_url,
        canada_prospect: @report.canada_locations,
        location_name: @report.location&.name.to_s,
        location_id: @report.location_id.to_s,
        hs_persona: stylist.present? ? 'persona_1' : 'persona_2',
        how_can_we_help_you: @report.how_can_we_help_you,
        would_you_like_to_subscribe_to_our_newsletter_: @report.newsletter,
        i_would_like_to_be_contacted: @report.i_would_like_to_be_contacted,
        dont_see_your_location: @report.dont_see_your_location,
        state: @report.state,
        zip: @report.zip_code,
        services: @report.services,
        source: @report.source,
        medium: @report.medium,
        campaign: @report.campaign,
        content: @report.content,
        hutk: @report.hutk,
        cms_lead_timestamp: @report.get_cms_lead_timestamp.utc.to_date.strftime('%Q').to_i,
        store_id: @report.location&.store_id.to_s,
      }
      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'], portal_id: ENV['HUBSPOT_PORTAL_ID'])
      Hubspot::Form.find("f86ac04f-4f02-4eea-8e75-788023163f9c").submit(data)
      HubspotLog.create(status: 'success', data: data, kind: 'request_tour_inquiry', action: 'form')
    rescue => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: data, kind: 'request_tour_inquiry', action: 'form')
      raise
    end

    def create_contact
      data = {
        email: @report.email,
        firstname: @report.first_name,
        lastname: @report.last_name,
        hubspot_owner_id: get_hubspot_owner_id(@report)
      }
      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])
      Hubspot::Contact.create_or_update!([data])
      HubspotLog.create(status: 'success', data: data, kind: 'request_tour_inquiry', action: 'contact')
    rescue => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: data, kind: 'request_tour_inquiry', action: 'contact')
      raise
    end
  end
end
