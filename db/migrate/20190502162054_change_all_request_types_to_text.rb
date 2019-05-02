class ChangeAllRequestTypesToText < ActiveRecord::Migration
  def change
  	change_column :request_tour_inquiries, :name, :text
  	change_column :request_tour_inquiries, :email, :text
  	change_column :request_tour_inquiries, :phone, :text
  	change_column :request_tour_inquiries, :request_url, :text
  	change_column :request_tour_inquiries, :contact_preference, :text
  end
end
