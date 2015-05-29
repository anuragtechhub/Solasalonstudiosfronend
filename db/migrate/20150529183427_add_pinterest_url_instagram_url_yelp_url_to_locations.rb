class AddPinterestUrlInstagramUrlYelpUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :pinterest_url, :string
    add_column :locations, :instagram_url, :string
    add_column :locations, :yelp_url, :string
  end
end
