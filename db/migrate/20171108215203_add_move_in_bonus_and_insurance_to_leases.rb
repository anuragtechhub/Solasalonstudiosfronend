class AddMoveInBonusAndInsuranceToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :move_in_bonus, :boolean, :default => false
    add_column :leases, :insurance, :boolean, :default => false
  end
end
