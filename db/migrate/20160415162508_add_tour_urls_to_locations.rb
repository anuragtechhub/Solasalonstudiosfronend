class AddTourUrlsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :tour_url_1, :string
    add_column :locations, :tour_url_2, :string
    add_column :locations, :tour_url_3, :string
  end
end
