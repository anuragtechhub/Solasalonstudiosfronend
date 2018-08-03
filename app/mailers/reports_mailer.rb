class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    report_email_address = @location.email_address_for_reports.present? ? @location.email_address_for_reports : @location.email_address_for_inquiries
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: report_email_address, bcc: ['nadia@solasalonstudios.com', 'jeff@jeffbail.com'], subject: "Sola Website Analytics Report: #{@location.name}")
  end

  def send_report(email_address, subject, csv_file)
  	attachments['report.csv'] = csv_file
  	mail(to: email_address, subject: subject)
  end

  def welcome_email_report(report_pdf)
    attachments["welcome_email_report.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: ['jennie@solasalonstudios.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
  end

end