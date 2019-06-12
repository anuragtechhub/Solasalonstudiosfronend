class AddSolageniusAccountCreatedAtToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :solagenius_account_created_at, :datetime
  end
end
