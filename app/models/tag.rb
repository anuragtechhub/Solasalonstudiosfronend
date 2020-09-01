class Tag < ActiveRecord::Base

  has_many :categoriables, as: :item, dependent: :destroy
  has_many :categories, through: :categoriables

  has_many :tags_videos
  has_many :videos, :through => :tags_videos

  has_many :taggables, inverse_of: :tag, dependent: :destroy
  # has_many :sola_stylist, through: :taggables, source: :item, source_type: 'SolaStylist'
  #
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
