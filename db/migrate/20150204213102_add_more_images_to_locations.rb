class AddMoreImagesToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :image_11
      t.attachment :image_12
      t.attachment :image_13
      t.attachment :image_14
      t.attachment :image_15
      t.attachment :image_16
      t.attachment :image_17
      t.attachment :image_18
      t.attachment :image_19
      t.attachment :image_20
    end
  end

  def self.down
    remove_attachment :locations, :image_11
    remove_attachment :locations, :image_12
    remove_attachment :locations, :image_13
    remove_attachment :locations, :image_14
    remove_attachment :locations, :image_15
    remove_attachment :locations, :image_16
    remove_attachment :locations, :image_17
    remove_attachment :locations, :image_18
    remove_attachment :locations, :image_19
    remove_attachment :locations, :image_20
  end
end
