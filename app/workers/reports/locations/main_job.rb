module Reports
  module Locations
    class MainJob < ::Reports::ReportJob
      def perform(country, start_date, end_date)
        # run locations_with_email
        Location.open.where(country: country).select(:id).find_each do |location|
          Reports::Locations::LocationJob.perform_async(location.id, start_date, end_date)
        end
      end
    end
  end
end
