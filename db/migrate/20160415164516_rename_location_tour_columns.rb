class RenameLocationTourColumns < ActiveRecord::Migration
  def change
    rename_column :locations, :tour_url_1, :tour_iframe_1
    rename_column :locations, :tour_url_2, :tour_iframe_2
    rename_column :locations, :tour_url_3, :tour_iframe_3
  end
end
