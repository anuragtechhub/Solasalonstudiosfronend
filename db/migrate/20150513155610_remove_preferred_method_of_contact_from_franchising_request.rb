class RemovePreferredMethodOfContactFromFranchisingRequest < ActiveRecord::Migration
  def change
    remove_column :franchising_requests, :preferred_method_of_contact, :string
  end
end
