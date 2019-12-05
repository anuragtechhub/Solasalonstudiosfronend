class AddMoveInAndMoveOutDateToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :move_out_date, :date
    # add_column :leases, :move_in_date, :date
  end
end
