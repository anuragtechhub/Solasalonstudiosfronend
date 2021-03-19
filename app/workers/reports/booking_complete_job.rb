module Reports
  class BookingCompleteJob < ::Reports::ReportJob
    def perform(start_date, end_date, email_address)
      start_date = Time.parse(start_date)
      end_date = Time.parse(end_date)
      analytics = Analytics.new
      app_data = analytics.booking_complete_data(GA_IDS['US'], start_date, end_date)

      html_renderer = HTMLRenderer.new

      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/booking_complete', { app_data: app_data }), footer: {center: '[page]', font_size: 7})

      ReportsMailer.booking_complete_report(email_address, pdf).deliver
    end
  end
end
