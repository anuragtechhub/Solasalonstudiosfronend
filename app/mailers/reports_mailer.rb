class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: (@location.email_address_for_reports || @location.email_address_for_inquiries), bcc: ['joseph@solasalonstudios.com', 'jeff@jeffbail.com'], subject: "Sola Website Analytics Report: #{@location.name}")
  end

end