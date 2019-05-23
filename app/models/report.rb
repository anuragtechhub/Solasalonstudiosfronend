class Report < ActiveRecord::Base

	validates :email_address, :report_type, :presence => true

  def report_type_enum
    [
    	#['All Booking Users Report', 'all_booking_user_report'],
    	['All Locations', 'all_locations'],
    	['All Contact Form Submissions', 'request_tour_inquiries'], 
    	['All Stylists', 'all_stylists'], 
      ['All Terminated Stylists Report', 'all_terminated_stylists_report'],
    	['Sola Pro / SolaGenius Penetration', 'solapro_solagenius_penetration']
    ]
  end

end