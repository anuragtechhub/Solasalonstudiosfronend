class AddPermittedUseBooleansToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :hair_styling_permitted, :boolean, :default => false unless ActiveRecord::Base.connection.column_exists?(:leases, :hair_styling_permitted)
    add_column :leases, :manicure_pedicure_permitted, :boolean, :default => false unless ActiveRecord::Base.connection.column_exists?(:leases, :manicure_pedicure_permitted)
    add_column :leases, :waxing_permitted, :boolean, :default => false unless ActiveRecord::Base.connection.column_exists?(:leases, :waxing_permitted)
    add_column :leases, :massage_permitted, :boolean, :default => false unless ActiveRecord::Base.connection.column_exists?(:leases, :massage_permitted)
    add_column :leases, :facial_permitted, :boolean, :default => false unless ActiveRecord::Base.connection.column_exists?(:leases, :facial_permitted)
  end
end
