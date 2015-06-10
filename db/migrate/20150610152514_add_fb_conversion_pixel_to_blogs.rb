class AddFbConversionPixelToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :fb_conversion_pixel, :text
  end
end
