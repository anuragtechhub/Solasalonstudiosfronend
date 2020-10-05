class AddImagesToSolaClasses < ActiveRecord::Migration
  def change
    add_column :sola_classes, :main_image_id, :integer
    add_column :sola_classes, :thumbnail_image_id, :integer
  end
end
