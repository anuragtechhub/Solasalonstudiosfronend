class AddServicesToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :services, :text
  end
end
