class AddUtmFieldsToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :utm_source, :string
    add_column :request_tour_inquiries, :utm_medium, :string
    add_column :request_tour_inquiries, :utm_campaign, :string
    add_column :request_tour_inquiries, :utm_content, :string
  end
end
