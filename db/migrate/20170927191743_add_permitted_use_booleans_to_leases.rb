class AddPermittedUseBooleansToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :hair_styling_permitted, :boolean, :default => false
    add_column :leases, :manicure_pedicure_permitted, :boolean, :default => false
    add_column :leases, :waxing_permitted, :boolean, :default => false
    add_column :leases, :massage_permitted, :boolean, :default => false
    add_column :leases, :facial_permitted, :boolean, :default => false
  end
end
