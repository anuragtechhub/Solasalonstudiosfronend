class AddHasSolaGeniusAccountSolaProPlatformAndSolaProVersionToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :has_sola_genius_account, :boolean, :default => false
    add_column :stylists, :sola_genius_enabled, :boolean, :default => false
    add_column :stylists, :sola_pro_platform, :string
    add_column :stylists, :sola_pro_version, :string
  end
end
