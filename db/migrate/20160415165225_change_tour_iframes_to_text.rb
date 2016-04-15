class ChangeTourIframesToText < ActiveRecord::Migration
  def change
    change_column :locations, :tour_iframe_1, :text
    change_column :locations, :tour_iframe_2, :text
    change_column :locations, :tour_iframe_3, :text
  end
end
