class CreateEducationHeroImages < ActiveRecord::Migration
  def change
    create_table :education_hero_images do |t|
      t.string :action_link
      t.string :image_content_type
      t.string :image_file_name
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :position

      t.timestamps
    end
  end
end
