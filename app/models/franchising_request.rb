class FranchisingRequest < ActiveRecord::Base

  after_create :send_notification_email

  private

  def send_notification_email
    email = PublicWebsiteMailer.franchising_request(self)
    p "email=#{email}"
    email.deliver if email
  end

end