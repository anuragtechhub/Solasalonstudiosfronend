class AddZipCodeToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :zip_code, :string
  end
end
