class AddCategoryIdToProBeautyIndustries < ActiveRecord::Migration
  def change
    add_reference :pro_beauty_industries, :category, index: true, foreign_key: true
    add_reference :supports, :category, index: true, foreign_key: true
    categories_mapping = {
      'Business & Marketing' => ['Salon Business', 'Tools and Resources'],
      'Inspiration' => ['Motivation'],
      'Product How-Tos' => ['Artistry', 'Video Tutorials']
    }

    tag_1 = Tag.find_or_create_by(name: 'Salon Business')
    tag_2 = Tag.find_or_create_by(name: 'Motivation')
    tag_3 = Tag.find_or_create_by(name: 'Artistry')
    tag_4 = Tag.find_or_create_by(name: 'Tools and Resources')
    tag_5 = Tag.find_or_create_by(name: 'Video Tutorials')
    tag_6 = Tag.find_or_create_by(name: 'Artistic')

    ProBeautyIndustry.find_each do |b|
      next if b.pro_beauty_industry_category.blank?
      new_cat = categories_mapping.select{|key, hash| b.pro_beauty_industry_category.name.in?(hash) }.first.try(:first)
      p "NFD #{b.pro_beauty_industry_category.name}" and next if new_cat.blank?
      cat = Category.find_by(name: new_cat)
      b.update_attribute(:category_id, cat.id)
      b.tags = [tag_1] if b.pro_beauty_industry_category.name == 'Salon Business'
      b.tags = [tag_2] if b.pro_beauty_industry_category.name == 'Motivation'
      b.tags = [tag_3] if b.pro_beauty_industry_category.name == 'Artistry'
    end

    Support.find_each do |b|
      next if b.support_category.blank?
      new_cat = categories_mapping.select{|key, hash| b.support_category.name.in?(hash) }.first.try(:first)
      p "NFD #{b.support_category.name}" and next if new_cat.blank?
      cat = Category.find_by(name: new_cat)
      b.update_attribute(:category_id, cat.id)
      b.tags = [tag_4] if b.support_category.name == 'Tools and Resources'
      b.tags = [tag_5] if b.support_category.name == 'Video Tutorials'
    end

    Video.find_each do |v|
      v.tags = Tag.where(id: v.tags_videos.pluck(:tag_id))
      if 'Artistic'.in?(v.video_categories.map(&:name))
        v.tags = v.tags.to_a | [tag_6]
      end
    end
  end
end
