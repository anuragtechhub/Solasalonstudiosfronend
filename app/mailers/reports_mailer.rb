class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    report_email_address = @location.email_address_for_reports.present? ? @location.email_address_for_reports : @location.email_address_for_inquiries
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: report_email_address, bcc: ['jeff@jeffbail.com'], subject: "Sola Website Analytics Report: #{@location.name}")
  end

  def send_report(email_address, subject, csv_file)
  	attachments['report.csv'] = csv_file
  	mail(to: email_address, subject: subject)
  end

  def booknow_report(email_address, report_pdf)
    attachments["booknow.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: email_address, bcc: ['jeff@jeffbail.com'], subject: "BookNow Report")
  end

  def booking_complete_report(email_address, report_pdf)
    attachments["booking_complete.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: email_address, bcc: ['jeff@jeffbail.com'], subject: "Booking Complete Report")
  end

  def welcome_email_report(report_pdf)
    attachments["welcome_email_report.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: ['jennie@solasalonstudios.com', 'megan@solasalonstudios.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
  end

  def location_contact_form_submission_report(email_addresses, csv_file, start_date, end_date)
    attachments['report.csv'] = csv_file
    mail(to: email_addresses, bcc: ['jeff@jeffbail.com'], subject: "Location Contact Form Submissions from #{start_date.strftime('%B %Y')} to #{end_date.strftime('%B %Y')}")
  end

end