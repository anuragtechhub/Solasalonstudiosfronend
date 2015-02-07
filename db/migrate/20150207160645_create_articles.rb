class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url_title
      t.text :summary
      t.text :body
      t.text :extended_text
      t.attachment :image
      
      t.timestamps
    end
  end
end
