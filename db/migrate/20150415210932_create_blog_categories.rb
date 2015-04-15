class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.string :url_name
      t.string :legacy_id

      t.timestamps
    end
  end
end
