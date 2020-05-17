class RequestTourInquiry < ActiveRecord::Base

  has_paper_trail
  
  belongs_to :location
  belongs_to :visit
  after_create :send_notification_email, :send_prospect_email, :sync_with_hubspot

  def first_name
    if name.present?
      return FullNameSplitter.split(name)[0]
    else
      return ''
    end
  end

  def last_name
    if name.present?
      return FullNameSplitter.split(name)[1]
    else
      return ''
    end
  end

  def location_name
    location.display_name if location
  end

  def contact_preference_enum
    [['Phone', 'phone'], ['Email', 'email'], ['Text', 'text']]
  end

  def newsletter_enum
    [['Yes', true], ['No', false]]
  end

  def i_would_like_to_be_contacted_enum
    [['Yes', true], ['No', false]]
  end

  def get_cms_lead_timestamp
    rti = RequestTourInquiry.where(:email => self.email).order(:created_at => :desc).first
    if rti
      return rti.created_at
    else
      return self.created_at || DateTime.now
    end
  end

  def sync_with_hubspot
    p "sync_with_hubspot!"

    if ENV['HUBSPOT_API_KEY'].present?
      p "HUBSPOT API KEY IS PRESENT, lets sync.. #{get_cms_lead_timestamp.utc.to_date.strftime('%Q').to_i}"
      
      stylist = Stylist.find_by(:email_address => self.email)

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'], portal_id: ENV['HUBSPOT_PORTAL_ID'])

      Hubspot::Form.find("f86ac04f-4f02-4eea-8e75-788023163f9c").submit({
        email: self.email,
        name: self.name,
        firstname: self.first_name,
        lastname: self.last_name,
        phone: self.phone,
        message: self.message,
        request_url: self.request_url,
        canada_prospect: self.canada_locations,
        location_name: self.location.present? ? self.location.name : '',
        location_id: self.location_id || '',
        hs_persona: stylist ? 'persona_1' : 'persona_2',
        how_can_we_help_you: self.how_can_we_help_you,
        would_you_like_to_subscribe_to_our_newsletter_: self.newsletter,
        i_would_like_to_be_contacted: self.i_would_like_to_be_contacted,
        dont_see_your_location: self.dont_see_your_location,
        state: self.state,
        zip: self.zip_code,
        services: self.services,
        source: self.source,
        medium: self.medium,
        campaign: self.campaign,
        content: self.content,
        hutk: self.hutk,
        cms_lead_timestamp: get_cms_lead_timestamp.utc.to_date.strftime('%Q').to_i,
      })

      contact_properties = {
        email: self.email,
        firstname: self.first_name,
        lastname: self.last_name,
      }

      hubspot_owner_id = get_hubspot_owner_id
      if hubspot_owner_id.present?
        p "yes, there is an owner #{hubspot_owner_id}"
        contact_properties[:hubspot_owner_id] = hubspot_owner_id
      end

      Hubspot::Contact.create_or_update!([contact_properties])
    else
      p "No HUBSPOT API KEY, no sync"
    end
  rescue => e
    # shh...
    p "error sync_with_hubspot #{e}"
  end

  # def get_hubspot_owners
  #   #p "get_hubspot_owners"

  #   if ENV['HUBSPOT_API_KEY'].present?
  #     #p "HUBSPOT API KEY IS PRESENT, lets get_hubspot_owners.."

  #     Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

  #     all_owners = Hubspot::Owner.all

  #     # p "all_owners=#{all_owners.inspect}"
  #     if all_owners
  #       all_owners = all_owners.map{|o| o.email}
  #       #p "all_owners=#{all_owners}"
  #     end
  #   else
  #     p "No HUBSPOT API KEY, get_hubspot_owners"
  #   end
  # rescue => e
  #   # shh...
  #   p "error get_hubspot_owners #{e}"
  # end

  def get_hubspot_owner_id(email_address=nil)
    if email_address.blank? && location
      if location.email_address_for_hubspot.present?
        email_address = location.email_address_for_hubspot
      else
        email_address = location.email_address_for_inquiries
      end
    end
    return nil unless email_address.present?
    
    #p "get_hubspot_owner #{email_address}"

    if ENV['HUBSPOT_API_KEY'].present?
      #p "HUBSPOT API KEY IS PRESENT, lets get_hubspot_owner.."

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

      all_owners = Hubspot::Owner.all

      # p "all_owners=#{all_owners.inspect}"
      if all_owners
        all_owners.each do |owner|
          if owner.email == email_address
            #p "matching owner!!! #{owner.inspect}"
            #p "owner.owner_id=#{owner.owner_id}"
            return owner.owner_id
          end
        end
      end

      return nil
    else
      p "No HUBSPOT API KEY, v"
      return nil
    end
  rescue => e
    # shh...
    p "error get_hubspot_owner #{e}"
    return nil
  end

  def utm_source
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_source"][0]
  rescue => e
    p "Error getting utm_source #{e}"
    return ''
  end

  def utm_medium
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_medium"][0]
  rescue => e
    p "Error getting utm_medium #{e}"
    return ''
  end

  def utm_campaign
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_campaign"][0]
  rescue => e
    p "Error getting utm_campaign #{e}"
    return ''
  end

  def utm_content
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_content"][0]
  rescue => e
    p "Error getting utm_content #{e}"
    return ''
  end

  private

  def send_notification_email
    if i_would_like_to_be_contacted == false && (send_email_to_prospect == 'modern_salon_2019_05' || 'financial_guide')
      p "shhh"
      p "do not contact me!"
    else
      p "contact me!"
      email = PublicWebsiteMailer.request_a_tour(self)
      email.deliver if email
    end
  rescue => e 
    p "caught an error #{e.inspect}"
  end

  def send_prospect_email
    if send_email_to_prospect == 'modern_salon_2019_05'
      p "send prospect the modern salon 2019_05 email!"
      email = PublicWebsiteMailer.modern_salon_2019_05(self)
      email.deliver if email
    elsif send_email_to_prospect == 'financial_guide'
      p "send prospect the financial guide email!"
      email = PublicWebsiteMailer.financial_guide(self)
      email.deliver if email
    end
  rescue => e 
    p "caught an error #{e.inspect}"
  end

  def i_would_like_to_be_contacted_value 
    if i_would_like_to_be_contacted 
      return 'Yes'
    else
      return 'No'
    end
  end

  def newsletter_value 
    if newsletter 
      return 'Yes'
    else
      return 'No'
    end
  end

end