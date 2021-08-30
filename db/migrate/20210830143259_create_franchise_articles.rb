class CreateFranchiseArticles < ActiveRecord::Migration
  def change
    create_table :franchise_articles do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.text :url
      t.text :summary
      t.text :body
      t.string :image_content_type
      t.string :image_file_name
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :author
      t.integer :country

      t.timestamps null: false
    end

    add_index :franchise_articles, :slug, unique: true
    add_index :franchise_articles, :title
    add_index :franchise_articles, :country
  end
end
