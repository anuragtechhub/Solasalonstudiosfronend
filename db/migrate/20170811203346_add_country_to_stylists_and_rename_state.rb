class AddCountryToStylistsAndRenameState < ActiveRecord::Migration
  def change
    rename_column :stylists, :state, :state_province
    add_column :stylists, :country, :string
  end
end
