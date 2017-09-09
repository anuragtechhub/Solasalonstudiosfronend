class RemoveDigitalDirectoryFields < ActiveRecord::Migration
  def change
    remove_attachment :locations, :floorplan_image
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
