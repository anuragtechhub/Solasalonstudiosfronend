class AddCreateDateToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :create_date, :date
  end
end
