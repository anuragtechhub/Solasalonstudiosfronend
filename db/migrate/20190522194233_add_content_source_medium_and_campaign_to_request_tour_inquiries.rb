class AddContentSourceMediumAndCampaignToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :content, :string
    add_column :request_tour_inquiries, :source, :string
    add_column :request_tour_inquiries, :medium, :string
    add_column :request_tour_inquiries, :campaign, :string
    remove_column :request_tour_inquiries, :associated_company
  end
end
