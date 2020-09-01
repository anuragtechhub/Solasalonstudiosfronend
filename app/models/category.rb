class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :categoriables, inverse_of: :category, dependent: :destroy
  has_many :blogs, through: :categoriables, source: :item, source_type: 'Blog'
  has_many :deals, through: :categoriables, source: :item, source_type: 'Deal'
  has_many :tools, through: :categoriables, source: :item, source_type: 'Tool'
  has_many :videos, through: :categoriables, source: :item, source_type: 'Video'
  has_many :tags, through: :categoriables, source: :item, source_type: 'Tag'
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_slug  (slug) UNIQUE
#