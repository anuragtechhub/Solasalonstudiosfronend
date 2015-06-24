class AddRequestUrlToContactForms < ActiveRecord::Migration
  def change
    add_column :franchising_requests, :request_url, :string
    add_column :request_tour_inquiries, :request_url, :string
    add_column :partner_inquiries, :request_url, :string
  end
end
