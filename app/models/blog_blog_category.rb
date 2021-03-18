class BlogBlogCategory < ActiveRecord::Base
  belongs_to :blog
  belongs_to :blog_category

  has_paper_trail
end

# == Schema Information
#
# Table name: blog_blog_categories
#
#  id               :integer          not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  blog_category_id :integer
#  blog_id          :integer
#
# Indexes
#
#  index_blog_blog_categories_on_blog_category_id  (blog_category_id)
#  index_blog_blog_categories_on_blog_id           (blog_id)
#
