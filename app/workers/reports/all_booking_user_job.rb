module Reports
  class AllBookingUserJob < ::Reports::ReportJob
    # looks like don't used
    def perform
      send_all_booking_user_report('jeff@jeffbail.com')
    end

    private

    def send_all_booking_user_report(email_address)
      start_date = Date.new(2019,1,1)
      end_date = Date.current
      analytics = Analytics.new
      app_data = analytics.booking_complete_data(GA_IDS['US'], start_date, end_date)

      csv_report = CSV.generate do |csv|
        csv << ['Name', 'Phone', 'Email', 'Booking Date']
        app_data[:booking_completes].each do |booking_complete|
          if booking_complete["booking_user"]
            csv << [booking_complete["booking_user"]["name"], booking_complete["booking_user"]["phone"], booking_complete["booking_user"]["email"], booking_complete["date"]]
          end
        end
      end


      ReportsMailer.send_report(email_address, 'All Booking Users Report', csv_report).deliver
    end
  end
end
