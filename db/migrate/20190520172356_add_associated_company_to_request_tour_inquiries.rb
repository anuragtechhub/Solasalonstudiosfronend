class AddAssociatedCompanyToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :associated_company, :string
  end
end
