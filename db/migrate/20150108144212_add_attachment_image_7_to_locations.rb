class AddAttachmentImage7ToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_7
    end
  end

  def self.down
    remove_attachment :locations, :image_7
  end
end
