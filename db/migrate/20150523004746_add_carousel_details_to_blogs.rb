class AddCarouselDetailsToBlogs < ActiveRecord::Migration
  def self.up
    add_attachment :blogs, :carousel_image
    add_column :blogs, :carousel_text, :string
  end

  def self.down
    remove_attachment :blogs, :carousel_image
    remove_column :blogs, :carousel_text, :string
  end
end
