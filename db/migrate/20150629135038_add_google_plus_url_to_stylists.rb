class AddGooglePlusUrlToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :google_plus_url, :string
  end
end
