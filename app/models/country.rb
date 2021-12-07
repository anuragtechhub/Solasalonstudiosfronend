class Country < ActiveRecord::Base
  has_many :blog_countries
  has_many :blogs, through: :blog_countries

  has_many :brand_countries
  has_many :brands, through: :brand_countries

  has_many :deal_countries
  has_many :deals, through: :deal_countries

  has_many :home_hero_image_countries
  has_many :home_hero_images, through: :home_hero_image_countries

  has_many :side_menu_item_countries
  has_many :side_menu_items, through: :side_menu_item_countries

  has_many :sola_class_region_countries, dependent: :destroy
  has_many :sola_class_regions, through: :sola_class_region_countries

  has_many :sola_class_countries
  has_many :sola_classes, through: :sola_class_countries

  has_many :tool_countries
  has_many :tools, through: :tool_countries

  has_many :video_countries
  has_many :videos, through: :video_countries

  validates :code, uniqueness: true
end

# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  domain     :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_countries_on_code  (code)
#
