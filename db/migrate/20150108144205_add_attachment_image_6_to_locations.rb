class AddAttachmentImage6ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_6
    end
  end

  def self.down
    remove_attachment :locations, :image_6
  end
end
