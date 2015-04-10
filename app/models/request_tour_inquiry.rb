class RequestTourInquiry < ActiveRecord::Base
  belongs_to :location

  after_create :send_notification_email

  private

  def send_notification_email
    email = PublicWebsiteMailer.request_a_tour(self)
    email.deliver if email
  end
end
