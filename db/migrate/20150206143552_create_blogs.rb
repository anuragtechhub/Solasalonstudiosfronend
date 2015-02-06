class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :url_title
      t.attachment :image
      t.text :summary
      t.text :body
      t.string :author

      t.timestamps
    end
  end
end
