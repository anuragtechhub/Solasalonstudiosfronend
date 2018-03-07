class RemoveHasSolaGeniusAccountFromStylists < ActiveRecord::Migration
  def change
  	remove_column :stylists, :has_sola_genius_account
  end
end
