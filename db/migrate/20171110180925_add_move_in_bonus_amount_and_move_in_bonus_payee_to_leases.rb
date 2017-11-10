class AddMoveInBonusAmountAndMoveInBonusPayeeToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :move_in_bonus_amount, :integer
    add_column :leases, :move_in_bonus_payee, :string
  end
end
