class AddYelpUrlToStylists < ActiveRecord::Migration
  def change
    add_column :stylists, :yelp_url, :string
  end
end
