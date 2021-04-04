namespace :hubspot do

  task :first_last => :environment do |task, args|
    begin
      if ENV['HUBSPOT_API_KEY'].present?
        p "HUBSPOT API KEY IS PRESENT, let's begin..."

        Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

        contactCount = 0
        contacts = []
        vidOffset = 49906551#nil
        hasMore = true
        startTime = DateTime.now

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
            p "contactCount=#{contactCount}"
            firstname = get_firstname(contact)
            lastname = get_lastname(contact)
            #email = get_email(contact)

            if firstname.present? && lastname.present?
              #p "do nothing - contact has a first and last name --- contactCount=#{contactCount} vid=#{vid}, firstname=#{firstname}, lastname=#{lastname}, email=#{email}"
            else
              #p "UPDATE CONTACT FIRST AND LAST NAME (if possible) --- contactCount=#{contactCount} vid=#{vid}, firstname=#{firstname}, lastname=#{lastname}"#, email=#{email}"
              vid = get_vid(contact)
              full_contact = Hubspot::Contact.find_by_id(vid)
              if full_contact['sola_id'].present?
                #stylist = Stylist.find_by(:id => full_contact['sola_id'])
                #if stylist
                  #p "found matching sola stylist! first_name=#{stylist.first_name}, last_name=#{stylist.last_name}"
                #end
              elsif full_contact['name'] && full_contact['name'].present?
                firstname = first_name(full_contact['name'])
                lastname = last_name(full_contact['name'])
                p "we got a name! #{full_contact['name']}, firstname=#{firstname}, lastname=#{lastname}"
                full_contact.update!({firstname: firstname, lastname: lastname})
              else
                #p "no name - no hope :( --- full_contact=#{full_contact.inspect}"
              end
              #
            end
          end

          p "contactCount=#{contactCount}, contactCount=#{contactCount}, start_time=#{startTime}, end_time=#{DateTime.now}"
        end
      else
        p "Hubspot API Key is NOT present, do nothing."
      end

      p "FINAL contactCount=#{contactCount}, contactCount=#{contactCount}, start_time=#{startTime}, end_time=#{DateTime.now}"
    rescue => e
      NewRelic::Agent.notice_error(e)
      p "ERRORRRRR! #{e.inspect}, contactCount=#{contactCount}, start_time=#{startTime}, end_time=#{DateTime.now}"
    end
  end




  def first_name(name)
    FullNameSplitter.split(name)[0]
  end

  def last_name(name)
    FullNameSplitter.split(name)[1]
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
      #p "contact['identity-profiles']=#{contact['identity-profiles'].inspect}"
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
