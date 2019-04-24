class AddNewsletterToRequestTourInquiry < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :newsletter, :boolean, :default => true
  end
end
