class AddAttachmentImage2ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_2
    end
  end

  def self.down
    remove_attachment :locations, :image_2
  end
end
