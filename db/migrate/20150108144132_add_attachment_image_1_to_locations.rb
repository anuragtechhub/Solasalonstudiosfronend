class AddAttachmentImage1ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_1
    end
  end

  def self.down
    remove_attachment :locations, :image_1
  end
end
