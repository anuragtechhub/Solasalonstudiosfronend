class AddStateToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :state, :string
  end
end
