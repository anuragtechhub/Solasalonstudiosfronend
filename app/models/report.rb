class Report < ActiveRecord::Base

	validates :email_address, :report_type, :presence => true

  def report_type_enum
    [['All Locations', 'all_locations'], ['All Stylists', 'all_stylists'], ['Sola Pro / SolaGenius Penetration', 'solapro_solagenius_penetration']]
  end

end