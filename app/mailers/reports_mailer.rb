class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    report_email_address = @location.email_address_for_reports.present? ? @location.email_address_for_reports : @location.email_address_for_inquiries
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: report_email_address, bcc: ['jeff@jeffbail.com', 'sola.analytics1@gmail.com', 'alderavellc@gmail.com'], subject: "Sola Website Analytics Report: #{@location.name}")
  end

  def location_pageview_drop_report(location, report_pdf)
    @location = location
    report_email_address = @location.email_address_for_reports.present? ? @location.email_address_for_reports : @location.email_address_for_inquiries
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: 'campbell@solasalonstudios.com', bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "PageView Drop Alert for #{@location.name}")
  end

  def send_report(email_address, subject, csv_file)
  	attachments['report.csv'] = csv_file
  	mail(to: email_address, subject: subject)
  end

  def booknow_report(email_address, report_pdf)
    attachments["booknow.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: email_address, bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "BookNow Report")
  end

  def booking_complete_report(email_address, report_pdf)
    attachments["booking_complete.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: email_address, bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "Booking Complete Report")
  end

  def welcome_email_report(report_pdf)
    attachments["welcome_email_report.pdf"] = report_pdf
    #mail(to: ['jeff@jeffbail.com'], bcc: ['jeff@jeffbail.com'], subject: "Sola Welcome Email Report")
    mail(to: ['jennie@solasalonstudios.com', 'megan@solasalonstudios.com', 'serge@codeart.us'], bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "Sola Welcome Email Report")
  end

  def solasalonstudios_report(report_pdf, url)
    @url = url
    attachments["#{url}.pdf"] = report_pdf
    mail(to: ['jennie@solasalonstudios.com', 'megan@solasalonstudios.com', 'angela@solasalonstudios.com', 'serge@codeart.us'], bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "Solasalonstudios analytics report")
  end

  def location_contact_form_submission_report(email_addresses, csv_file, start_date, end_date)
    attachments['report.csv'] = csv_file
    mail(to: email_addresses, bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "Location Contact Form Submissions from #{start_date.strftime('%B %Y')} to #{end_date.strftime('%B %Y')}")
  end

  def rent_manager_locations(email_addresses, summary, locations_csv)
    if email_addresses.present?
      @summary = summary
      attachments['locations.csv'] = locations_csv
      mail(to: email_addresses, bcc: ['jeff@jeffbail.com', 'alderavellc@gmail.com'], subject: "Rent Manager Location Match Task Summary")
    end
  end
end
