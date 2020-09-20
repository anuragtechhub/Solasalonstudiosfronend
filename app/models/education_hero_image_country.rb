class EducationHeroImageCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :education_hero_image
end

# == Schema Information
#
# Table name: education_hero_image_countries
#
#  id                      :integer          not null, primary key
#  country_id              :integer
#  education_hero_image_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#
# Indexes
#
#  index_education_hero_image_countries_on_country_id               (country_id)
#  index_education_hero_image_countries_on_education_hero_image_id  (education_hero_image_id)
#
