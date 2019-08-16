class AddDescriptionShortAndDescriptionLongToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :description_short, :text
    add_column :locations, :description_long, :text
  end
end
