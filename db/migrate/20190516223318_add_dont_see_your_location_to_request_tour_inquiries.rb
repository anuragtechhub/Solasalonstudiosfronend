class AddDontSeeYourLocationToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :dont_see_your_location, :boolean, :default => false
  end
end
