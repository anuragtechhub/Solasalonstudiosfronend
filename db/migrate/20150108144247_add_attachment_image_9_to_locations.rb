class AddAttachmentImage9ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_9
    end
  end

  def self.down
    remove_attachment :locations, :image_9
  end
end
