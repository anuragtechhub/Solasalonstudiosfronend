class AddIWouldLikeToBeContactedToFranchisingRequests < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :i_would_like_to_be_contacted, :boolean, :default => true
  end
end
