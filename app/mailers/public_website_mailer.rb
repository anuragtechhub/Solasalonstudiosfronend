class PublicWebsiteMailer < ActionMailer::Base
  default :from => "notifications@solasalonstudios.com"

  def request_a_tour(requestTourInquiry)
    if requestTourInquiry.location && requestTourInquiry.location.email_address_for_inquiries && requestTourInquiry.location.email_address_for_inquiries.present?
      @inquiry = requestTourInquiry
      mail(to: 'jeff@jeffbail.com', subject: 'Request a Tour Inquiry') #requestTourInquiry.location.email_address_for_inquiries
    end
  end
end