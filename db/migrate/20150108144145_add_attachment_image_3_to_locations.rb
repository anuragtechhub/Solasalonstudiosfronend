class AddAttachmentImage3ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_3
    end
  end

  def self.down
    remove_attachment :locations, :image_3
  end
end
