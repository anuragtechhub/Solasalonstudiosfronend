class HomeHeroImageCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :home_hero_image
end

# == Schema Information
#
# Table name: home_hero_image_countries
#
#  id                 :integer          not null, primary key
#  country_id         :integer
#  home_hero_image_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  index_home_hero_image_countries_on_country_id          (country_id)
#  index_home_hero_image_countries_on_home_hero_image_id  (home_hero_image_id)
#
