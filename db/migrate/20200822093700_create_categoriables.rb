class CreateCategoriables < ActiveRecord::Migration
  def change
    create_table :categoriables do |t|
      t.references :category, index: true
      t.references :item, polymorphic: true, index: true

      t.timestamps
    end

    categories_mapping = {
      'Hair' => ['Hair & Beauty', 'Step by Step', 'Product', 'Beauty and Style', 'Styling Tools', 'Other', 'Product Information'],
      'Nails' => ['Nails'],
      'Business & Marketing' => ['Marketing & Business Tips', 'Business & Marketing', 'Online Education', 'Insurance'],
      'Inspiration' => ['Inspirtation & Motivation', 'Artistic', 'Inspiration & Motivation'],
      'Sanitation' => ['COVID-19'],
      'Community' => ['#MySola', 'Industry Happenings', 'Philanthropy', 'Sola Spotlights', 'All About Sola', 'Sola Exclusive'],
      'Lifestyle' => ['Studio Inspiration', 'Healthy Lifestyle', 'Lifestyle'],
      'Sola Stories Podcast' => ['Sola Stories Podcast:'],
      'Technology' => ['SolaGenius', 'Past Webinars']
    }

    tags_mapping = {
      'Hair' => ['Step by Step', 'Product', 'Extensions', 'Smoothing', 'Braid', 'Texture', 'Curls', 'Updo',
                 'Ponytail', 'Volume', 'Pixie', 'Straight', 'Waves',
                 'Color', 'Red', 'Brunette', 'Blonde', 'Highlights',
                 'Summer Hair', 'Balayage', 'Grey', 'Long Hair', 'Short Hair',
                 'Bob', 'Square Bob', 'Blow Dry', 'Gray'],
      'Barbering' => ['Grooming', 'Barber'],
      'Skin' => ['Skincare'],
      'Sanitation' => ['COVID-19'],
      'Community' => ['All About Sola', '#MySola', 'Philanthropy', 'Sola Spotlights', 'Industry Happenings', 'Sola Exclusive'],
      'Lifestyle' => ['Studio Inspiration'],
      'Sola Stories Podcast' => ['Sola Stories Podcast'],
      'Business & Marketing' => ['Business & Marketing', 'Social Media', 'Brand', 'Trademarking'],
      'Inspiration' => ['Inspirtation & Motivation', 'Artistic', 'Nina Kovner'],
      'Product How-Tos' => ['Tools'],
      'Technology' => ['SolaGenius', 'Past Webinars']
    }

    Blog.find_each do |b|
      b.blog_categories.map(&:name).uniq.each do |old_category|
        new_cat = categories_mapping.select{|key, hash| old_category.in?(hash) }.first.try(:first)
        p "NFD #{old_category}" and next if new_cat.blank?
        cat = Category.find_by(name: new_cat)
        b.categoriables.where(category_id: cat.id).first_or_create
      end
    end

    Video.find_each do |b|
      b.video_categories.map(&:name).uniq.each do |old_category|
        new_cat = categories_mapping.select{|key, hash| old_category.in?(hash) }.first.try(:first)
        p "NFD #{old_category}" and next if new_cat.blank?
        cat = Category.find_by(name: new_cat)
        b.categoriables.where(category_id: cat.id).first_or_create
      end
    end

    Deal.find_each do |b|
      b.deal_categories.map(&:name).uniq.each do |old_category|
        new_cat = categories_mapping.select{|key, hash| old_category.in?(hash) }.first.try(:first)
        p "NFD #{old_category}" and next if new_cat.blank?
        cat = Category.find_by(name: new_cat)
        b.categoriables.where(category_id: cat.id).first_or_create
      end
    end

    Tool.find_each do |b|
      b.tool_categories.map(&:name).uniq.each do |old_category|
        new_cat = categories_mapping.select{|key, hash| old_category.in?(hash) }.first.try(:first)
        p "NFD #{old_category}" and next if new_cat.blank?
        cat = Category.find_by(name: new_cat)
        b.categoriables.where(category_id: cat.id).first_or_create
      end
    end

    Tag.find_each do |t|
      new_cat = tags_mapping.select{|key, hash| t.name.in?(hash) }.first.try(:first)
      p "NFD #{t.name}" and next if new_cat.blank?
      cat = Category.find_by(name: new_cat)
      t.categoriables.where(category_id: cat.id).first_or_create
    end
  end
end
