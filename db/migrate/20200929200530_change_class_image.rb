class ChangeClassImage < ActiveRecord::Migration
  def change
    remove_column :sola_classes, :thumbnail_image_id
    remove_column :sola_classes, :main_image_id
    remove_column :class_images, :kind

    add_column :sola_classes, :class_image_id, :integer
    add_column :class_images, :thumbnail_content_type, :string
    add_column :class_images, :thumbnail_file_name, :string
    add_column :class_images, :thumbnail_file_size, :integer
    add_column :class_images, :thumbnail_updated_at, :datetime
  end
end
