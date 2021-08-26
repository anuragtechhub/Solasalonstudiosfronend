class AddCountryToFranchisingForms < ActiveRecord::Migration
  def change
    add_column :franchising_forms, :country, :string, null: false, default: 'usa'
    add_index :franchising_forms, :country
  end
end
