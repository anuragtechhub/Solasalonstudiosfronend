module Reports
  class LocationsContactFormSubmissionsJob < ::Reports::ReportJob
    def perform(start_date, end_date)
      start_date = Time.parse(start_date)
      end_date = Time.parse(end_date)
      csv_report = CSV.generate do |csv|
        csv << ['Month', 'Location', 'Store ID', 'Contact Form Submissions']
        months = (start_date.to_date..end_date.to_date).select {|d| d.day == 1}
        months.each do |month|
          Location.open.order(:name).each do |location|
            csv << [month.strftime('%B %Y'), location.name, location.store_id,
                    RequestTourInquiry.where('location_id = ? AND how_can_we_help_you != ? AND (created_at <= ? AND created_at >= ?)', location.id, "Book an appointment with a salon professional", month.end_of_month, month.beginning_of_month).count]
          end
        end

      end

      ReportsMailer.location_contact_form_submission_report(csv_report, start_date, end_date).deliver
    end
  end
end
