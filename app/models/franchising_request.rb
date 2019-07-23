class FranchisingRequest < ActiveRecord::Base

  has_paper_trail
  
 	#after_create :send_notification_email
  belongs_to :visit

  # private

  # def send_notification_email
  #   email = PublicWebsiteMailer.franchising_request(self)
  #   email.deliver if email
  # end

end