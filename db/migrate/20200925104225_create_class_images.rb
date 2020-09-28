class CreateClassImages < ActiveRecord::Migration
  def change
    create_table :class_images do |t|
      t.integer :kind, index: true
      t.string :name
      t.string :image_content_type
      t.string :image_file_name
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
