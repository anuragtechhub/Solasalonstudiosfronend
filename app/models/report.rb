class Report < ActiveRecord::Base

	validates :email_address, :report_type, presence: true
	after_create :process

  def report_type_enum
    [
    	['All Locations', 'all_locations'],
    	['All Contact Form Submissions', 'request_tour_inquiries'],
    	['All Stylists', 'all_stylists'],
      ['All Terminated Stylists Report', 'all_terminated_stylists_report'],
    	['Sola Pro / SolaGenius Penetration', 'solapro_solagenius_penetration']
    ]
	end

	def email_subject
		subject.presence || "#{report_type.titleize} Report"
	end

  private

  def process
		Reports::SingleReportJob.perform_async(self.id)
	end
end

# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  email_address :string(255)
#  parameters    :string(255)
#  processed_at  :datetime
#  report_type   :string(255)
#  subject       :string
#  created_at    :datetime
#  updated_at    :datetime
#
