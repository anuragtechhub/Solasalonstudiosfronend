class RequestTourInquiry < ActiveRecord::Base
  has_paper_trail

  belongs_to :location
  belongs_to :visit
  after_create :send_notification_email, :send_prospect_email
  after_commit :sync_with_hubspot, on: :create

  def first_name
    FullNameSplitter.split(name.to_s)[0].to_s
  end

  def last_name
    FullNameSplitter.split(name.to_s)[1].to_s
  end

  def location_name
    location&.display_name
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
    rti = RequestTourInquiry.where(email: self.email).order(created_at: :desc).first
    rti.present? ? rti.created_at : (self.created_at || Time.current)
  end

  def sync_with_hubspot
    ::Hubspot::RequestTourJob.perform_async(self.id)
  end

  def utm_source
    uri = URI::parse(request_url)
    CGI::parse(uri.query)["utm_source"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_medium
    uri = URI::parse(request_url)
    CGI::parse(uri.query)["utm_medium"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_campaign
    uri = URI::parse(request_url)
    CGI::parse(uri.query)["utm_campaign"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def utm_content
    uri = URI::parse(request_url)
    CGI::parse(uri.query)["utm_content"][0]
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
    return ''
  end

  def send_notification_email
    unless i_would_like_to_be_contacted == false && send_email_to_prospect.to_s.in?(%w[modern_salon_2019_05 financial_guide])
      PublicWebsiteMailer.request_a_tour(self).deliver_later
    end
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def send_prospect_email
    if send_email_to_prospect == 'modern_salon_2019_05'
      PublicWebsiteMailer.modern_salon_2019_05(self).deliver_later
    elsif send_email_to_prospect == 'financial_guide'
      PublicWebsiteMailer.financial_guide(self).deliver_later
    end
  rescue => e
    Rollbar.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def i_would_like_to_be_contacted_value
    i_would_like_to_be_contacted ? 'Yes' : 'No'
  end

  def newsletter_value
    newsletter ? 'Yes' : 'No'
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
