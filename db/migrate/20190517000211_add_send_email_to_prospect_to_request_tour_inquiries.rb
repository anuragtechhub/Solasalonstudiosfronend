class AddSendEmailToProspectToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :send_email_to_prospect, :string
  end
end
