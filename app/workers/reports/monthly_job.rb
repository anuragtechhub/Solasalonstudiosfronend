# frozen_string_literal: true

module Reports
  class MonthlyJob < ::Reports::ReportJob
    def perform
      start_date = Date.current.prev_month.beginning_of_month.beginning_of_day
      end_date = Date.current.prev_month.end_of_month.end_of_day

      Reports::LocationsContactFormSubmissionsJob.perform_async(start_date, end_date)
      Reports::SolasalonstudiosJob.perform_async(start_date, end_date, 'CA')
      Reports::SolasalonstudiosJob.perform_async(start_date, end_date, 'US')

      Reports::BookingCompleteJob.perform_async(start_date, end_date, 'olivia@solasalonstudios.com')
      Reports::BooknowJob.perform_async(start_date, end_date, 'olivia@solasalonstudios.com')

      Reports::Locations::MainJob.perform_async('CA', start_date, end_date)
      Reports::Locations::MainJob.perform_async('US', start_date, end_date)

      # https://bbac.atlassian.net/browse/SSS-227
      # Stylists report
      Report.create(email_address: 'dave@radianceholdings.com,christian.rathke@radianceholdings.com,nathan@radianceholdings.com',
                    report_type:   'all_stylists',
                    subject:       "Sola Stylist Data #{Time.current.strftime('%B')}")
    end
  end
end
