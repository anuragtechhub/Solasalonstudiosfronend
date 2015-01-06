class AddAttachmentFloorplanImageToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :floorplan_image
    end
  end

  def self.down
    remove_attachment :locations, :floorplan_image
  end
end
