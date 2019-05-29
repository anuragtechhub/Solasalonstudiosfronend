class RequestTourInquiry < ActiveRecord::Base

  has_paper_trail
  
  belongs_to :location
  belongs_to :visit
  after_create :send_notification_email, :send_prospect_email, :sync_with_hubspot

  def location_name
    location.display_name if location
  end

  def contact_preference_enum
    [['Phone', 'phone'], ['Email', 'email'], ['Text', 'text']]
  end

  def newsletter_enum
    [['Yes', true], ['No', false]]
  end

  def sync_with_hubspot
    p "sync_with_hubspot!"

    if ENV['HUBSPOT_API_KEY'].present?
      p "HUBSPOT API KEY IS PRESENT, lets sync.."

      Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'], portal_id: ENV['HUBSPOT_PORTAL_ID'])

      Hubspot::Form.find("f86ac04f-4f02-4eea-8e75-788023163f9c").submit({
        email: self.email,
        name: self.name,
        phone: self.phone,
        message: self.message,
        request_url: self.request_url,
        location_id: self.location_id || '',
        hs_persona: 'persona_2',
        how_can_we_help_you: self.how_can_we_help_you,
        would_you_like_to_subscribe_to_our_newsletter_: self.newsletter,
        i_would_like_to_be_contacted: self.i_would_like_to_be_contacted,
        dont_see_your_location: self.dont_see_your_location,
        zip: self.zip_code,
        services: self.services,
        source: self.source,
        medium: self.medium,
        campaign: self.campaign,
        content: self.content,
      })
    else
      p "No HUBSPOT API KEY, no sync"
    end
  rescue => e
    # shh...
    p "error sync_with_hubspot #{e}"
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
    if i_would_like_to_be_contacted
      p "contact me!"
      email = PublicWebsiteMailer.request_a_tour(self)
      email.deliver if email
    else
      p "do not contact me!"
    end
  end

  def send_prospect_email
    if send_email_to_prospect == 'modern_salon_2019_05'
      p "send prospect the modern salon 2019_05 email!"
      email = PublicWebsiteMailer.modern_salon_2019_05(self)
      email.deliver if email
    end
  end
end
