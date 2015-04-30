class StylistMessage < ActiveRecord::Base
  
  after_create :send_email

  belongs_to :stylist

  private

  def send_email
    if stylist
      email = PublicWebsiteMailer.stylist_message(self)
      email.deliver if email
    end
  end

end