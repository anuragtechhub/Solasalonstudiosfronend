class AddAltTextToStylistImages < ActiveRecord::Migration
  def change
    add_column :stylists, :image_1_alt_text, :text
    add_column :stylists, :image_2_alt_text, :text
    add_column :stylists, :image_3_alt_text, :text
    add_column :stylists, :image_4_alt_text, :text
    add_column :stylists, :image_5_alt_text, :text
    add_column :stylists, :image_6_alt_text, :text
    add_column :stylists, :image_7_alt_text, :text
    add_column :stylists, :image_8_alt_text, :text
    add_column :stylists, :image_9_alt_text, :text
    add_column :stylists, :image_10_alt_text, :text
  end
end
