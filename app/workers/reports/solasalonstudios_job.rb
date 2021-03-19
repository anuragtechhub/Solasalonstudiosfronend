module Reports
  class SolasalonstudiosJob < ::Reports::ReportJob
    def perform(start_date, end_date, country)
      start_date = Time.parse(start_date)
      end_date = Time.parse(end_date)
      @ga_id = GA_IDS[country]
      @url = URLS[country]
      analytics = Analytics.new
      data = analytics.solasalonstudios_data(@ga_id, start_date, end_date, @url)

      html_renderer = HTMLRenderer.new

      pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/solasalonstudios_ga', { data: data, url: @url }), footer: {center: '[page]', font_size: 7})
      ReportsMailer.solasalonstudios_report(pdf, @url).deliver
    end
  end
end
