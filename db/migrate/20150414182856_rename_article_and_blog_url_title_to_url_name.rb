class RenameArticleAndBlogUrlTitleToUrlName < ActiveRecord::Migration
  def change
    rename_column :articles, :url_title, :url_name
    rename_column :blogs, :url_title, :url_name
  end
end
