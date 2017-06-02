class ReportsMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <reports@solasalonstudios.com>"

  def location_report(location, report_pdf)
    @location = location
    attachments["#{@location.url_name}.pdf"] = report_pdf
    mail(to: 'jeff@jeffbail.com', bcc: 'joseph@solasalonstudios.com', subject: "Website Analytics Report: #{@location.name}")
  end

end