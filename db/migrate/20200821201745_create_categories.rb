class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true

    ['Hair', 'Barbering', 'Skin', 'Nails', 'Business & Marketing',
     'Inspiration', 'Sanitation', 'Product How-Tos', 'Community',
     'Lifestyle', 'Sola Stories Podcast', 'Technology'].each do |c|
      Category.find_or_create_by(name: c)
    end
  end
end
