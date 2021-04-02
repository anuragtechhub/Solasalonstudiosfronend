module Reports
  class SingleReportJob < ::Reports::ReportJob
    def perform(report_id)
      @report = Report.find(report_id)
      return if @report.processed_at.present?
      return if @report.email_address.blank?

      csv_report = case @report.report_type
      when 'all_locations'
        all_locations
      when 'all_stylists'
        all_stylists
      when 'solapro_solagenius_penetration'
        solapro_solagenius_penetration
      when 'request_tour_inquiries'
        all_request_tour_inquiries
      when 'all_terminated_stylists_report'
        all_terminated_stylists
      end
      ReportsMailer.send_report(@report.email_address, "#{@report.report_type.titleize} Report", csv_report).deliver
      @report.update_column(:processed_at, DateTime.current)
    end

    private

    def all_locations
      CSV.generate do |csv|
        csv << ['ID', 'Name', 'URL Name', 'Address 1', 'Address 2', 'City',
                'State', 'Postal Code', 'Country', 'Email Address', 'Phone Number',
                'Contact Name', 'Description', 'Facebook URL', 'Pinterest URL',
                'Instagram URL', 'Twitter URL', 'Yelp URL', 'Move In Special', 'Open House']

        Location.open.order(created_at: :desc).find_each do |location|
          csv << [location.id, location.name, location.url_name, location.address_1, location.address_2,
                  location.city, location.state, location.postal_code, location.country,
                  location.email_address_for_inquiries, location.phone_number,
                  location.general_contact_name, location.description, location.facebook_url,
                  location.pinterest_url, location.instagram_url, location.twitter_url, location.yelp_url,
                  location.move_in_special, location.open_house]
        end
      end
    end

    def all_stylists
      CSV.generate do |csv|
        csv << ['ID', 'First Name', 'Last Name', 'URL Name', 'Email Address', 'Phone Number',
                'Website URL', 'Booking URL', 'Pinterest URL', 'Facebook URL', 'Twitter URL',
                'Instagram URL', 'Yelp URL', 'Emergency Contact Name', 'Emergency Contact Relationship',
                'Emergency Contact Phone Number', 'Brows', 'Hair', 'Hair Exensions', 'Laser Hair Removal',
                'Lashes', 'Makeup', 'Massage', 'Microblading', 'Nails', 'Permanent Makeup', 'Skincare',
                'Tanning', 'Teeth Whitening', 'Threading', 'Waxing', 'Other Service', 'Studio Number',
                'Location ID', 'Location Name', 'Location City', 'Location State', 'Country', 'Has Sola Pro',
                'Has SolaGenius', 'Sola Pro Start Date', 'Sola Pro Platform', 'Sola Pro Version']

        Stylist.open.order(created_at: :desc).find_each do |stylist|
          next if stylist.location.blank?
          csv << [stylist.id, stylist.first_name, stylist.last_name, stylist.url_name, stylist.email_address, stylist.phone_number,
                  stylist.website_url, stylist.booking_url, stylist.pinterest_url, stylist.facebook_url, stylist.twitter_url,
                  stylist.instagram_url, stylist.yelp_url, stylist.emergency_contact_name, stylist.emergency_contact_relationship,
                  stylist.emergency_contact_phone_number, stylist.brows, stylist.hair, stylist.hair_extensions, stylist.laser_hair_removal,
                  stylist.eyelash_extensions, stylist.makeup, stylist.massage, stylist.microblading, stylist.nails,
                  stylist.permanent_makeup, stylist.skin, stylist.tanning, stylist.teeth_whitening, stylist.threading,
                  stylist.waxing, stylist.other_service, stylist.studio_number, stylist.location.id, stylist.location.name,
                  stylist.location.city, stylist.location.state, stylist.country, stylist.has_sola_pro_login,
                  stylist.has_sola_genius_account, stylist.sola_pro_start_date, stylist.sola_pro_platform, stylist.sola_pro_version]
        end
      end
    end


    def solapro_solagenius_penetration
      CSV.generate do |csv|
        csv << ['Location ID', 'Location Name', 'Location City', 'Location State',
                'Stylists on Website', 'Has Sola Pro Account', 'Has SolaGenius Account']
        Location.open.order(created_at: :desc).find_each do |location|
          csv << [location.id, location.name, location.city, location.state,
                  location.stylists.size, location.stylists_using_sola_pro.size,
                  location.stylists_using_sola_genius.size]
        end
      end
    end

    def all_request_tour_inquiries
      start_date = 1.month.ago
      end_date = Date.today
      params = @report.parameters
      if params
        params = params.split(',').map!(&:strip)
        p "params=#{params}"
        params.each do |param|
          start_date = Date.parse(param.split('=')[1]) if param.include? 'start_date'
          end_date = Date.parse(param.split('=')[1]) if param.include? 'end_date'
        end
      end

      CSV.generate do |csv|
        csv << ["Name", "Email", "Phone", "Message", "URL", "Created At",
                "Location Name", "Matching Sola Stylist Email?",
                "How Can We Help You?", "Contact Preference"]
        RequestTourInquiry.where('created_at BETWEEN :start AND :end', start: start_date, end: end_date).order(created_at: :desc).find_each do |rti|
          if rti.location
            stylist = Stylist.find_by(email_address: rti.email)
            csv << [rti.name, rti.email, rti.phone, rti.message, rti.request_url,
                    rti.created_at, rti.location.name, (stylist ? 'Yes' : 'No'),
                    rti.how_can_we_help_you, rti.contact_preference]
          end
        end
      end
    end


    def all_terminated_stylists
      CSV.generate do |csv|
        csv << ['Name', 'Phone', 'Email', 'Studio Number', 'Created At', 'Terminated At']
        TerminatedStylist.order(created_at: :desc).find_each do |terminated_stylist|
          csv << [terminated_stylist.name, terminated_stylist.phone_number,
                  terminated_stylist.email_address, terminated_stylist.studio_number,
                  terminated_stylist.stylist_created_at, terminated_stylist.created_at]
        end
      end
    end
  end
end
