class StylistMessage < ActiveRecord::Base

  has_paper_trail

  after_create :send_email

  belongs_to :stylist
  belongs_to :visit

  private

  def send_email
    if stylist
      email = PublicWebsiteMailer.stylist_message(self)
      email.deliver if email
    end
  end

end