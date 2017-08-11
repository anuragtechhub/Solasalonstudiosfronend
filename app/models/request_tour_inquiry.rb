class RequestTourInquiry < ActiveRecord::Base

  has_paper_trail
  
  belongs_to :location
  belongs_to :visit
  after_create :send_notification_email

  def location_name
    location.display_name if location
  end

  private

  def send_notification_email
    email = PublicWebsiteMailer.request_a_tour(self)
    email.deliver if email
  end
end
