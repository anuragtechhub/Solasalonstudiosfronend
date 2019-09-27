namespace :hubspot do

  task :first_last do
    if ENV['HUBSPOT_API_KEY'].present?
      p "HUBSPOT API KEY IS PRESENT, let's begin..."

      contactCount = 0
      contacts = []
      vidOffset = nil
      hasMore = true

      while hasMore do
        all_contacts_response = `curl -X GET \
          'https://api.hubapi.com/contacts/v1/lists/all/contacts/all?hapikey=#{ENV['HUBSPOT_API_KEY']}&count=100&vidOffset=#{vidOffset}'`

        #p "all_contacts_response=#{all_contacts_response.inspect}"

        all_contacts_response_json = JSON.parse(all_contacts_response)
        hasMore = all_contacts_response_json['has-more']
        vidOffset = all_contacts_response_json['vid-offset']

        #p "all_contacts_response_json=#{all_contacts_response_json.inspect}"
        p "hasMore=#{hasMore}, vidOffset=#{vidOffset}"

        contacts = all_contacts_response_json["contacts"]

        contacts.each do |contact|
          contactCount = contactCount + 1
          p "contact contactCount=#{contactCount} vid=#{get_vid(contact)}, firstname=#{get_firstname(contact)}, lastname=#{get_lastname(contact)}, email=#{get_email(contact)}"
        end
      end
    else
      p "Hubspot API Key is NOT present, do nothing."
    end
  end

  def get_vid(contact)
    if contact && contact['vid']
      return contact['vid']
    end
  end

  def get_firstname(contact)
    if contact && contact['properties'] && contact['properties']['firstname'] && contact['properties']['firstname']['value']
      return contact['properties']['firstname']['value']
    end
  end

  def get_lastname(contact)
    if contact && contact['properties'] && contact['properties']['lastname'] && contact['properties']['lastname']['value']
      return contact['properties']['lastname']['value']
    end
  end

  def get_email(contact)
    if contact && contact['identity-profiles']

      contact && contact['identity-profiles'].each do |identity_profile|
        identity_profile['identities'].each do |identity|
          if identity && identity['type'] == 'EMAIL'
            return identity['value']
          end
        end
      end
    end
  end

end