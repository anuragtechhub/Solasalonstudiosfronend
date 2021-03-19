module Reports
  module Locations
    class LocationJob < ::Reports::ReportJob
      def perform(location_id, start_date, end_date)
        start_date = Time.parse(start_date)
        end_date = Time.parse(end_date)
        @location = Location.find(location_id)
        @ga_id = GA_IDS[@location.country]
        @url = URLS[@location.country]

        location_ga_report(@location, start_date, end_date)
      end

      private

      def location_ga_report(location, start_date, end_date)
        analytics = ::Analytics.new
        data = analytics.location_data(@ga_id, location, start_date, end_date)

        # sola pro, sola genius, etc numbers
        data[:salon_professionals_on_sola_website] = location.stylists.size
        data[:salon_professionals_on_solagenius] = location.stylists.select{|s| s.has_sola_genius_account }.size
        data[:salon_professionals_on_sola_pro] = location.stylists.where("encrypted_password IS NOT NULL AND encrypted_password <> ''").size

        # leasing submissions
        data[:leasing_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', start_date.beginning_of_day, end_date.end_of_day, location.id, 'Request leasing information').count
        data[:leasing_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', start_date.prev_month.beginning_of_month.beginning_of_day, end_date.prev_month.end_of_month.end_of_day, location.id, 'Request leasing information').count
        data[:leasing_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', (start_date - 1.year).beginning_of_month.beginning_of_day, (end_date - 1.year).end_of_month.end_of_day, location.id, 'Request leasing information').count

        # book appointment submissions
        data[:book_an_appointment_inquiries_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', start_date.beginning_of_day, end_date.end_of_day, location.id, 'Book an appointment with a salon professional').count
        data[:book_an_appointment_inquiries_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', start_date.prev_month.beginning_of_month.beginning_of_day, end_date.prev_month.end_of_month.end_of_day, location.id, 'Book an appointment with a salon professional').count
        data[:book_an_appointment_inquiries_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND how_can_we_help_you = ?)', (start_date - 1.year).beginning_of_month.beginning_of_day, (end_date - 1.year).end_of_month.end_of_day, location.id, 'Book an appointment with a salon professional').count

        # other (everything else)
        data[:other_form_submissions_current_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL))', start_date.beginning_of_day, end_date.end_of_day, location.id, 'Other').count
        data[:other_form_submissions_prev_month] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL))', start_date.prev_month.beginning_of_month.beginning_of_day, end_date.prev_month.end_of_month.end_of_day, location.id, 'Other').count
        data[:other_form_submissions_prev_year] = RequestTourInquiry.where('(created_at >= ? AND created_at <= ? AND location_id = ? AND (how_can_we_help_you = ? OR how_can_we_help_you IS NULL))', (start_date - 1.year).beginning_of_month.beginning_of_day, (end_date - 1.year).end_of_month.end_of_day, location.id, 'Other').count

        data[:total_form_submissions_current_month] = data[:other_form_submissions_current_month] + data[:book_an_appointment_inquiries_current_month] + data[:leasing_form_submissions_current_month]
        data[:total_form_submissions_prev_month] = data[:other_form_submissions_prev_month] + data[:book_an_appointment_inquiries_prev_month] + data[:leasing_form_submissions_prev_month]
        data[:total_form_submissions_prev_year] = data[:other_form_submissions_prev_year] + data[:book_an_appointment_inquiries_prev_year] + data[:leasing_form_submissions_prev_year]

        locals = { data: data }

        html_renderer = HTMLRenderer.new

        pdf = WickedPdf.new.pdf_from_string(html_renderer.build_html('reports/location_ga', locals), :footer => {:center => '[page]', :font_size => 7})

        ReportsMailer.location_report(location, pdf).deliver
      end
    end
  end
end
