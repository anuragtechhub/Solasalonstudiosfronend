class AddMessageToRequestTourInquiry < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :message, :text
  end
end
