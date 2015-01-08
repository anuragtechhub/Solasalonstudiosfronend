class AddAttachmentImage4ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_4
    end
  end

  def self.down
    remove_attachment :locations, :image_4
  end
end
