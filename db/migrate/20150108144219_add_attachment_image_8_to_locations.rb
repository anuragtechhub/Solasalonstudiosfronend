class AddAttachmentImage8ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_8
    end
  end

  def self.down
    remove_attachment :locations, :image_8
  end
end
