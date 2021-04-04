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
        store_id: self.location.present? ? self.location.store_id : '',
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
      else
        # If no hubspot owner is found, remove contact's existing owner (if any)
        # This will prevent deals being created and assigned to the wrong hubspot owner
        contact_properties[:hubspot_owner_id] = nil
      end

      Hubspot::Contact.create_or_update!([contact_properties])
    else
      p "No HUBSPOT API KEY, no sync"
    end
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

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
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return nil
  end

  def utm_source
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_source"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_medium
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_medium"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_campaign
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_campaign"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_content
    uri = URI::parse(request_url)
    params = CGI::parse(uri.query)
    return params["utm_content"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def send_notification_email
    if i_would_like_to_be_contacted == false && send_email_to_prospect.to_s.in?(%w[modern_salon_2019_05 financial_guide])
      p "do not contact me!"
    else
      p "contact me!"
      email = PublicWebsiteMailer.request_a_tour(self)
      email.deliver if email
    end
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
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
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
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

# == Schema Information
#
# Table name: request_tour_inquiries
#
#  id                           :integer          not null, primary key
#  campaign                     :string(255)
#  canada_locations             :boolean          default(FALSE)
#  contact_preference           :text
#  content                      :string(255)
#  dont_see_your_location       :boolean          default(FALSE)
#  email                        :text
#  how_can_we_help_you          :text
#  hutk                         :string(255)
#  i_would_like_to_be_contacted :boolean          default(TRUE)
#  medium                       :string(255)
#  message                      :text
#  name                         :text
#  newsletter                   :boolean          default(TRUE)
#  phone                        :text
#  request_url                  :text
#  send_email_to_prospect       :string(255)
#  services                     :text
#  source                       :string(255)
#  state                        :string(255)
#  zip_code                     :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  location_id                  :integer
#  visit_id                     :integer
#
# Indexes
#
#  index_request_tour_inquiries_on_location_id  (location_id)
#  index_request_tour_inquiries_on_visit_id     (visit_id)
#
