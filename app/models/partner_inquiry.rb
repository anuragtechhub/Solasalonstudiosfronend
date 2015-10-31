class PartnerInquiry < ActiveRecord::Base

  after_create :send_notification_email
  belongs_to :visit
  
  private

  def send_notification_email
    email = PublicWebsiteMailer.partner_inquiry(self)
    email.deliver if email
  end

end
