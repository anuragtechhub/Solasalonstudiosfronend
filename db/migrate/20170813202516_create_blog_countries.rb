class CreateBlogCountries < ActiveRecord::Migration
  def change
    create_table :blog_countries do |t|
      t.references :blog, index: true
      t.references :country, index: true

      t.timestamps
    end
  end
end
