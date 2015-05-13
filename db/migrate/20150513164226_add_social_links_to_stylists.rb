class AddSocialLinksToStylists < ActiveRecord::Migration
  def up
    add_column :stylists, :pinterest_url, :string
    add_column :stylists, :facebook_url, :string
    add_column :stylists, :twitter_url, :string
    add_column :stylists, :instagram_url, :string
  end

  def down
    remove_column :stylists, :pinterest_url
    remove_column :stylists, :facebook_url
    remove_column :stylists, :twitter_url
    remove_column :stylists, :instagram_url
  end
end
