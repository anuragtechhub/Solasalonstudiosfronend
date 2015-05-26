class PublicWebsiteMailer < ActionMailer::Base
  default :from => "inquiry@solasalonstudios.com"

  def request_a_tour(requestTourInquiry)
    if requestTourInquiry && requestTourInquiry.location && requestTourInquiry.location.email_address_for_inquiries && requestTourInquiry.location.email_address_for_inquiries.present?
      @inquiry = requestTourInquiry
      mail(to: 'jeff@jeffbail.com', from: @inquiry.email, subject: @inquiry.message.present? ? 'Contact Us' : 'Request a Tour Inquiry') #requestTourInquiry.location.email_address_for_inquiries
    end
  end

  def stylist_message(stylistMessage)
    if stylistMessage && stylistMessage.stylist && stylistMessage.stylist.email_address && stylistMessage.stylist.email_address.present?
      @message = stylistMessage
      mail(to: 'jeff@jeffbail.com', from: @message.email, subject: 'Sola Website Inquiry') #stylistMessage.stylist.email_address
    end
  end

  def franchising_request(franchisingRequest)
    if franchisingRequest
      @message = franchisingRequest
      mail(to: 'jeff@jeffbail.com', from: @message.email || "inquiry@solasalonstudios.com", subject: 'Sola Salon Studios Franchising Request') #mark@solasalonstudios.com
    end
  end

end