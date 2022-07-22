# frozen_string_literal: true

module Hubspot
  class BookNowJob < ::Hubspot::MainJob
    def perform(book_now_id)
      return if ENV['HUBSPOT_API_KEY'].blank?
      @book_now = BookNowBooking.find(book_now_id)
      data = {
        email:              @book_now.stylist.email_address.to_s.strip,
        location_name:      @book_now.location&.name.to_s,
        location_id:        @book_now.location_id.to_s,
        time_range:         @book_now.time_range,
        services_booked:    @book_now.services_booked,
        query:              @book_now.query,
        booking_user_name:  @book_now.booking_user_name,
        booking_user_phone: @book_now.booking_user_phone,
        booking_user_email: @book_now.booking_user_email.to_s.strip,
        referring_url:      @book_now.referring_url,
        total:              @book_now.total
      }
      Hubspot.configure(hapikey: ENV.fetch('HUBSPOT_API_KEY', nil), portal_id: ENV.fetch('HUBSPOT_PORTAL_ID', nil))
      Hubspot::Form.find('49552c63-f86b-4207-bb27-df3b568da6fa').submit(data)
      HubspotLog.create(status: 'success', data: data, kind: 'book_now', action: 'form')
      ScheduledJobLog.create(status: 'success', data: data, kind: 'book_now', fired_at: Time.current)
      
    rescue StandardError => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: data, kind: 'book_now', action: 'form')
      ScheduledJobLog.create(status: 'error', data: data, kind: 'book_now', fired_at: Time.current)
      raise
    end
  end
end
