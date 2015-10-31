class AddVisitToFranchisingRequests < ActiveRecord::Migration
  def change
    add_reference :franchising_requests, :visit, index: true
  end
end
