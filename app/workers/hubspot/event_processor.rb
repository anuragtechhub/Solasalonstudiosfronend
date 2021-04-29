module Hubspot
  class EventProcessor < ::Hubspot::MainJob

    def perform(hubspot_event_id)
      hubspot_event = HubspotEvent.find(hubspot_event_id)
      json = hubspot_event.json.with_indifferent_access

      location = Location.find_by(name: json[:location_name][:value])
      stylist = Stylist.find_or_create_by(email_address: json[:email_address][:value])
      stylist.update_column(:phone_number, json[:phone_number][:value])
      stylist.update_column(:location_id, location.id) if stylist.location.blank? && location.present?
      json[:services][:value].to_s.downcase.split(', ').each do |service|
        next unless stylist.has_attribute?(service)
        stylist.update_column(service,true)
      end
    end
  end
end
