class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    report_email_address = @location.email_address_for_reports.present? ? @location.email_address_for_reports : @location.email_address_for_inquiries
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: 'report_email_address', bcc: ['joseph@solasalonstudios.com', 'jeff@jeffbail.com'], subject: "Sola Website Analytics Report: #{@location.name}")
  end

end