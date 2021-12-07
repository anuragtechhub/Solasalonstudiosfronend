module Hubspot
  class StylistJob < ::Hubspot::MainJob

    def perform(stylist_id, type)
      return if ENV['HUBSPOT_API_KEY'].blank?
      @stylist = Stylist.find_by(id: stylist_id)
      return if @stylist.blank?
      return if @stylist.email_address.blank?

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])
      properties = type == 'inactivate' ? inactivate_properties : contact_properties
      hubspot_owner_id = get_hubspot_owner_id(@stylist)
      if hubspot_owner_id.present?
        properties[:hubspot_owner_id] = hubspot_owner_id
      end
      Hubspot::Contact.create_or_update!([properties])
      HubspotLog.create(status: 'success', data: properties,
                        object: @stylist, location: @stylist.location,
                        kind: 'stylist', action: 'contact')
    rescue => e
      raise unless type == 'inactivate'
      Rollbar.error(e)
      NewRelic::Agent.notice_error(e)
      HubspotLog.create(status: 'error', data: properties,
                        object: @stylist, location: @stylist.location,
                        kind: 'stylist', action: 'contact')
    end

    private

    def inactivate_properties
      contact_properties.merge({
        lease_move_in_date: @stylist.lease&.move_in_date&.utc&.to_date&.strftime('%Q')&.to_i,
        lease_move_out_date: @stylist&.lease&.move_out_date&.utc&.to_date&.strftime('%Q')&.to_i,
        lease_created_at: @stylist&.lease&.create_date&.utc&.to_date&.strftime('%Q')&.to_i,
        lease_start_date: @stylist&.lease&.start_date&.utc&.to_date&.strftime('%Q')&.to_i,
        lease_end_date: @stylist&.lease&.end_date&.utc&.to_date&.strftime('%Q')&.to_i,
        studios_at_location: @stylist.studios_at_location,
        leases_at_location: @stylist.leases_at_location,
        hs_persona: 'persona_7'
      }).compact
    end

    def contact_properties
      {
        email: @stylist.email_address.strip,
        firstname: @stylist.first_name,
        lastname: @stylist.last_name,
        phone: @stylist.phone_number,
        sola_pro_status: @stylist.hubspot_status,
        inactive_reason: @stylist.inactive_reason_human,
        sola_id: @stylist.id,
        website: @stylist.website_url,
        booking_url: @stylist.booking_url,
        solagenius_booking_url: (@stylist.has_sola_genius_account.presence && @stylist.booking_url),
        solagenius_account_created_at: @stylist.solagenius_account_created_at.present? ? @stylist.solagenius_account_created_at.to_date.strftime('%Q').to_i : nil,
        pinterest_url: @stylist.pinterest_url,
        facebook_url: @stylist.facebook_url,
        emergency_contact_relationship: @stylist.emergency_contact_relationship,
        emergency_contact_number: @stylist.emergency_contact_phone_number,
        lashes: @stylist.eyelash_extensions,
        teeth_whitening: @stylist.teeth_whitening,
        waxing: @stylist.waxing,
        location_id: @stylist.location_id.to_s,
        location_name: @stylist.location&.name.to_s,
        location_state: @stylist.location&.state.to_s,
        country: @stylist.country,
        has_sola_pro: @stylist.has_sola_pro_login,
        has_solagenius: @stylist.has_sola_genius_account,
        hs_persona: 'persona_1',
        total_booknow_bookings: @stylist.total_booknow_bookings,
        total_booknow_revenue: @stylist.total_booknow_revenue
      }
      #twitter_url: @stylist.twitter_url,
      #yelp_url: @stylist.yelp_url,
      #emergency_contact_name: @stylist.emergency_contact_name,
      #brows: @stylist.brows,
      #hair: @stylist.hair,
      #hair_extensions: @stylist.hair_extensions,
      #laser_hair_removal: @stylist.laser_hair_removal,
      #makeup: @stylist.makeup,
      #massage: @stylist.massage,
      #microblading: @stylist.microblading,
      #nails: @stylist.nails,
      #permanent_makeup: @stylist.permanent_makeup,
      #skincare: @stylist.skin,
      #tanning: @stylist.tanning,
      #threading: @stylist.threading,
      #other_service: @stylist.other_service,
      #studio_number: @stylist.studio_number,
      #location_city: @stylist.location&.city.to_s,
    end
  end
end
