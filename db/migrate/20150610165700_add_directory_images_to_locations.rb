class AddDirectoryImagesToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :directory_image_1
      t.attachment :directory_image_2
      t.attachment :directory_image_3
      t.attachment :directory_image_4
      t.attachment :directory_image_5
      t.attachment :directory_image_6
      t.attachment :directory_image_7
      t.attachment :directory_image_8
      t.attachment :directory_image_9
      t.attachment :directory_image_10
      t.attachment :directory_image_11
      t.attachment :directory_image_12
    end
  end

  def self.down
    remove_attachment :locations, :directory_image_1
    remove_attachment :locations, :directory_image_2
    remove_attachment :locations, :directory_image_3
    remove_attachment :locations, :directory_image_4
    remove_attachment :locations, :directory_image_5
    remove_attachment :locations, :directory_image_6
    remove_attachment :locations, :directory_image_7
    remove_attachment :locations, :directory_image_8
    remove_attachment :locations, :directory_image_9
    remove_attachment :locations, :directory_image_10
    remove_attachment :locations, :directory_image_11
    remove_attachment :locations, :directory_image_12
  end
end
