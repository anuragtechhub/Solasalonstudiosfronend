# frozen_string_literal: true

class PublicWebsiteMailerPreview < ActionMailer::Preview
  def welcome_email_us
    PublicWebsiteMailer.welcome_email_us(Stylist.last)
  end
end
