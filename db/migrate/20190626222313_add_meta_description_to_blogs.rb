class AddMetaDescriptionToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :meta_description, :text
  end
end
