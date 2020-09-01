class AddCategoryToSollaClass < ActiveRecord::Migration
  def change
    add_column :sola_classes, :category_id, :integer
    add_index :sola_classes, :category_id

    Tag.pluck(:name).each do |name|
      next if Tag.where('name = ?', name).count <= 1

      puts "Processing: #{name}\n"
      active = Tag.where('name = ?', name).order(:created_at).first
      Tag.where('name = ?', name).where.not(id: active.id).find_each do |tag|
        TagsVideo.where(tag_id: tag.id).update_all(tag_id: active.id)
        tag.destroy
      end
    end

    add_index :tags, :name, unique: true

    categories_mapping = {
      'Hair' => ['Hair', 'Hair & Beauty', 'Step by Step', 'Product', 'Beauty and Style', 'Styling Tools', 'Other', 'Product Information'],
      'Nails' => ['Nails'],
      'Skin' => ['Skincare', 'Makeup'],
      'Business & Marketing' => ['Business Development', 'Marketing & Business Tips', 'Business & Marketing', 'Online Education', 'Insurance'],
      'Inspiration' => ['Inspirtation & Motivation', 'Artistic', 'Inspiration & Motivation'],
      'Sanitation' => ['COVID-19'],
      'Community' => ['#MySola', 'Industry Happenings', 'Philanthropy', 'Sola Spotlights', 'All About Sola', 'Sola Exclusive', 'The Sola Sessions'],
      'Lifestyle' => ['Studio Inspiration', 'Healthy Lifestyle', 'Lifestyle'],
      'Sola Stories Podcast' => ['Sola Stories Podcast:'],
      'Technology' => ['Software', 'SolaGenius', 'Past Webinars']
    }

    SolaClass.find_each do |b|
      next if b.sola_class_category.blank?
      new_cat = categories_mapping.select{|key, hash| b.sola_class_category.name.in?(hash) }.first.try(:first)
      p "NFD #{b.sola_class_category.name}" and next if new_cat.blank?
      cat = Category.find_by(name: new_cat)
      b.update_attribute(:category_id, cat.id)
    end
  end
end
