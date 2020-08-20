class AddUtmSourceToFranchisingForms < ActiveRecord::Migration
  def change
    add_column :franchising_forms, :utm_source, :string unless column_exists?(:franchising_forms, :utm_source)
    add_column :franchising_forms, :utm_campaign, :string unless column_exists?(:franchising_forms, :utm_campaign)
    add_column :franchising_forms, :utm_medium, :string unless column_exists?(:franchising_forms, :utm_medium)
    add_column :franchising_forms, :utm_content, :string unless column_exists?(:franchising_forms, :utm_content)
    add_column :franchising_forms, :utm_term, :string unless column_exists?(:franchising_forms, :utm_term)
  end
end
