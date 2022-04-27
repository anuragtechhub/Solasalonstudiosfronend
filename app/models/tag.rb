# frozen_string_literal: true

class Tag < ActiveRecord::Base
  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, inverse_of: :tag, dependent: :destroy

  has_many :stylists, through: :taggables, source: :item, source_type: 'Stylist'
  has_many :videos, through: :taggables, source: :item, source_type: 'Video'

  validates :name, uniqueness: true
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
