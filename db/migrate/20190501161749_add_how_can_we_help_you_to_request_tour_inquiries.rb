class AddHowCanWeHelpYouToRequestTourInquiries < ActiveRecord::Migration
  def change
  	add_column :request_tour_inquiries, :how_can_we_help_you, :string
  end
end
