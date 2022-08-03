class AddCountryIdToFranchiseArticle < ActiveRecord::Migration
  def change
    add_column :franchise_articles, :country_id, :integer, foreign_key: true
  end
end
