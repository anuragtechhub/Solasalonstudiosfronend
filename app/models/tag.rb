# frozen_string_literal: true

class Tag < ActiveRecord::Base
    include PgSearch::Model
  pg_search_scope :search_by_tag_id_and_name, against: [:id, :name],
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :taggables, inverse_of: :tag, dependent: :destroy

  has_many :stylists, through: :taggables, source: :item, source_type: 'Stylist'
  has_many :videos, through: :taggables, source: :item, source_type: 'Video'

  validates :name, uniqueness: true


  def as_json(_options = {})
    super(methods: %i[category video stylist ])
  end

  def category
    self.categories&.map{ | a| {id: a.id, name: a.name} }
  end

  def video
    self.videos&.map{ | a| {id: a.id, title: a.title} }
  end 

  def stylist
    self.stylists&.map{ | a| {id: a.id, name: a.name} }
  end 
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
