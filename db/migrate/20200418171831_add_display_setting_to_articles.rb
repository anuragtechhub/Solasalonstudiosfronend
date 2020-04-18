class AddDisplaySettingToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :display_setting, :string, :default => 'sola_website'
  end
end
