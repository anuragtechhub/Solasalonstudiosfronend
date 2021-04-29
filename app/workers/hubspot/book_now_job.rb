module Hubspot
  class BookNowJob < ::Hubspot::MainJob

    def perform(book_now_id)
      return if ENV['HUBSPOT_API_KEY'].blank?

      @book_now = BookNowBooking.find(book_now_id)
      data = {
        email: @book_now.stylist.email_address,
        location_name: @book_now.location&.name.to_s,
        location_id: @book_now.location_id.to_s,
        time_range: @book_now.time_range,
        services_booked: @book_now.services_booked,
        query: @book_now.query,
        booking_user_name: @book_now.booking_user_name,
        booking_user_phone: @book_now.booking_user_phone,
        booking_user_email: @book_now.booking_user_email,
        referring_url: @book_now.referring_url,
        total: @book_now.total
      }
      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'], portal_id: ENV['HUBSPOT_PORTAL_ID'])
      Hubspot::Form.find("49552c63-f86b-4207-bb27-df3b568da6fa").submit(data)
      HubspotLog.create(status: 'success', data: data, kind: 'book_now', action: 'form')
    rescue => e
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: data, kind: 'book_now', action: 'form')
      raise
    end
  end
end
