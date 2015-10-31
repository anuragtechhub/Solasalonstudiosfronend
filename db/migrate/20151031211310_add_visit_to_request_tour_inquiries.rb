class AddVisitToRequestTourInquiries < ActiveRecord::Migration
  def change
    add_reference :request_tour_inquiries, :visit, index: true
  end
end
