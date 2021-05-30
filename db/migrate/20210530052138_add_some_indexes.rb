class AddSomeIndexes < ActiveRecord::Migration
  def change
    add_index :blogs, :url_name
    add_index :articles, :url_name
    add_index :blog_categories, :url_name
  end
end
