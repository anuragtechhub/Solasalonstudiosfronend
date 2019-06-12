class AddHutkToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :hutk, :string
  end
end
