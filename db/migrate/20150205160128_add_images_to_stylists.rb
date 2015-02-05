class AddImagesToStylists < ActiveRecord::Migration
  def self.up
    change_table :stylists do |t|
      t.attachment :image_1
      t.attachment :image_2
      t.attachment :image_3
      t.attachment :image_4
      t.attachment :image_5
      t.attachment :image_6
      t.attachment :image_7
      t.attachment :image_8
      t.attachment :image_9
      t.attachment :image_10
    end
  end

  def self.down
    remove_attachment :stylists, :image_1
    remove_attachment :stylists, :image_2
    remove_attachment :stylists, :image_3
    remove_attachment :stylists, :image_4
    remove_attachment :stylists, :image_5
    remove_attachment :stylists, :image_6
    remove_attachment :stylists, :image_7
    remove_attachment :stylists, :image_8
    remove_attachment :stylists, :image_9
    remove_attachment :stylists, :image_10
  end
end
