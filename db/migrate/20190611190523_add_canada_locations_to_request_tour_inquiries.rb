class AddCanadaLocationsToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :canada_locations, :boolean, :default => false
  end
end
