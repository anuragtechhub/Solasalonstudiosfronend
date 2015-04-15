class CreateBlogBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_blog_categories do |t|
      t.references :blog, index: true
      t.references :blog_category, index: true

      t.timestamps
    end
  end
end
