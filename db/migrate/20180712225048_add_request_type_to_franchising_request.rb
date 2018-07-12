class AddRequestTypeToFranchisingRequest < ActiveRecord::Migration
  def change
    add_column :franchising_requests, :request_type, :string
  end
end
