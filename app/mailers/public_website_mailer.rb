class PublicWebsiteMailer < ActionMailer::Base
  default :from => "notifications@solasalonstudios.com"

  def request_a_tour(requestTourInquiry)
    if requestTourInquiry && requestTourInquiry.location && requestTourInquiry.location.email_address_for_inquiries && requestTourInquiry.location.email_address_for_inquiries.present?
      @inquiry = requestTourInquiry
      mail(to: 'jeff@jeffbail.com', subject: 'Request a Tour Inquiry') #requestTourInquiry.location.email_address_for_inquiries
    end
  end

  def stylist_message(stylistMessage)
    if stylistMessage && stylistMessage.stylist && stylistMessage.stylist.email_address && stylistMessage.stylist.email_address.present?
      @message = stylistMessage
      mail(to: 'jeff@jeffbail.com', subject: 'Sola Salon Studios Message') #stylistMessage.stylist.email_address
    end
  end

end