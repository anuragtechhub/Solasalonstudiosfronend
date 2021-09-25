class AddInactiveReasonToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :inactive_reason, :integer
  end
end
