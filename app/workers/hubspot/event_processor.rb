module Hubspot
  class EventProcessor < ::Hubspot::MainJob

    def perform(hubspot_event_id)
      hubspot_event = HubspotEvent.find(hubspot_event_id)
      json = hubspot_event.data.with_indifferent_access
      email = json.dig(:properties, :email_address, :value)
      return if email.blank?

      location = Location.find_by(name: json.dig(:properties, :location_name, :value))
      stylist = Stylist.find_or_create_by(email_address: email)

      phone = json.dig(:properties, :phone_number, :value)
      stylist.update_column(:phone_number, phone) if phone.present?

      stylist.update_column(:location_id, location.id) if stylist.location.blank? && location.present?

      json.dig(:properties, :services, :value).to_s.downcase.split(', ').each do |service|
        next unless stylist.has_attribute?(service)
        stylist.update_column(service,true)
      end
    end
  end
end
