class AddThumbnailToFranchiseArticles < ActiveRecord::Migration
  def change
    add_column :franchise_articles, :thumbnail_content_type, :string
    add_column :franchise_articles, :thumbnail_file_name, :string
    add_column :franchise_articles, :thumbnail_file_size, :integer
    add_column :franchise_articles, :thumbnail_updated_at, :datetime
  end
end
