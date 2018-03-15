class PublicWebsiteMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <inquiry@solasalonstudios.com>"

  def request_a_tour(requestTourInquiry)
    if requestTourInquiry && requestTourInquiry.location && requestTourInquiry.location.email_address_for_inquiries && requestTourInquiry.location.email_address_for_inquiries.present?
      @inquiry = requestTourInquiry
      mail(to: requestTourInquiry.location.email_address_for_inquiries, from: ("Sola Salon Studios <inquiry@solasalonstudios.com>"), subject: @inquiry.message.present? ? 'Sola Contact Us Inquiry' : 'Sola Rent a Studio Inquiry') #requestTourInquiry.location.email_address_for_inquiries
    end
  end

  def stylist_message(stylistMessage)
    if stylistMessage && stylistMessage.stylist && stylistMessage.stylist.email_address && stylistMessage.stylist.email_address.present?
      @message = stylistMessage
      mail(to: stylistMessage.stylist.website_email_address.present? ? stylistMessage.stylist.website_email_address : stylistMessage.stylist.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Website Inquiry') #stylistMessage.stylist.email_address
    end
  end

  def franchising_request(franchisingRequest)
    if franchisingRequest
      @message = franchisingRequest
      mail(to: 'ben@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Franchising Request')
    end
  end

  def partner_inquiry(partnerInquiry)
    if partnerInquiry
      @inquiry = partnerInquiry
      mail(to: 'info@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Partner Inquiry')
    end
  end

  def forgot_password(admin)
    if admin
      @key = admin.forgot_password_key
      @username = admin.email
      mail(to: admin.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Forgot Password Reset')
    end
  end

  def stylist_website_is_updated(update_my_sola_website)
    if update_my_sola_website
      @update_my_sola_website = update_my_sola_website
      if @update_my_sola_website && @update_my_sola_website.stylist && @update_my_sola_website.stylist.email_address
        mail(to: @update_my_sola_website.stylist.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Your Sola Website Has Been Updated!')
      end
    end
  end

  def update_my_sola_website_reminder(update_my_sola_website)
    if update_my_sola_website
      @update_my_sola_website = update_my_sola_website
      if @update_my_sola_website && @update_my_sola_website.stylist && @update_my_sola_website.stylist.email_address
        mail(to: @update_my_sola_website.location.admin.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Update My Sola Website Reminder for ' + @update_my_sola_website.stylist.name)
      end
    end
  end

  def welcome_email_us(stylist)
    mail(to: stylist.email_address, from: "Jennie at Sola <jennie@solasalonstudios.com>", subject: 'Welcome to Sola')
  end

end