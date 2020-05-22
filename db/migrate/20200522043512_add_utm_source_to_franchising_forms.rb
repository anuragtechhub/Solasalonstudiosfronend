class AddUtmSourceToFranchisingForms < ActiveRecord::Migration
  def change
    add_column :franchising_forms, :utm_source, :string
    add_column :franchising_forms, :utm_campaign, :string
    add_column :franchising_forms, :utm_medium, :string
    add_column :franchising_forms, :utm_content, :string
    add_column :franchising_forms, :utm_term, :string
  end
end
