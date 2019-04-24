class AddContactPreferenceToRequestTourInquiry < ActiveRecord::Migration
  def change
    add_column :request_tour_inquiries, :contact_preference, :string
  end
end
