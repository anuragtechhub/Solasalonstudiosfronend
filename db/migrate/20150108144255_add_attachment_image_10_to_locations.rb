class AddAttachmentImage10ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_10
    end
  end

  def self.down
    remove_attachment :locations, :image_10
  end
end
