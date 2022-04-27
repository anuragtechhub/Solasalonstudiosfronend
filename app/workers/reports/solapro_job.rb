# frozen_string_literal: true

# TODO: setup events in GA. Or fix using current events
module Reports
  class SolaProJob < ::Reports::ReportJob
    def perform(start_date, end_date)
      start_date = Time.zone.parse(start_date)
      end_date = Time.zone.parse(end_date)
      analytics = Analytics.new
      app_data = if start_date && end_date
                   analytics.solapro_app_data(GA_IDS['SOLAPRO'], start_date, end_date)
                 else
                   analytics.solapro_app_data
                 end

      html_renderer = HTMLRenderer.new

      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/solapro_ga', { app_data: app_data }), footer: { center: '[page]', font_size: 7 })
      save_path = Rails.root.join('pdfs', 'solapro.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end
  end
end
