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
      mail(to: stylistMessage.stylist.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Website Inquiry') #stylistMessage.stylist.email_address
    end
  end

  def franchising_request(franchisingRequest)
    if franchisingRequest
      @message = franchisingRequest
      mail(to: 'info@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Franchising Request')
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
      mail(to: 'melissa@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Your Sola Website Has Been Updated!')
    end
  end

end