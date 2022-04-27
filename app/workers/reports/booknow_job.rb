# frozen_string_literal: true

module Reports
  class BooknowJob < ::Reports::ReportJob
    def perform(start_date, end_date, email_address)
      start_date = Time.zone.parse(start_date)
      end_date = Time.zone.parse(end_date)
      analytics = Analytics.new
      app_data = analytics.booknow_data(GA_IDS['US'], start_date, end_date)

      html_renderer = HTMLRenderer.new
      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/booknow_ga', { app_data: app_data }), footer: { center: '[page]', font_size: 7 })

      ReportsMailer.booknow_report(email_address, pdf).deliver
    end
  end
end
