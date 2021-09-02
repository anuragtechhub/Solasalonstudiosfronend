class AddKindToFranchiseArticles < ActiveRecord::Migration
  def change
    add_column :franchise_articles, :kind, :integer, null: false, default: 0, limit: 2
  end
end
