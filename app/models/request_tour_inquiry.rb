class RequestTourInquiry < ActiveRecord::Base

  has_paper_trail
  
  belongs_to :location
  belongs_to :visit
  after_create :send_notification_email, :sync_with_hubspot

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
        phone_number: self.phone,
        message: self.message,
        request_url: self.request_url,
        location_id: self.location_id || '',
        hs_persona: 'persona_2',
        would_you_like_to_subscribe_to_our_newsletter_: self.newsletter
      })
    else
      p "No HUBSPOT API KEY, no sync"
    end
  rescue => e
    # shh...
    p "error sync_with_hubspot #{e}"
  end

  private

  def send_notification_email
    email = PublicWebsiteMailer.request_a_tour(self)
    email.deliver if email
  end
end
