# frozen_string_literal: true

require 'test_helper'

class EducationHeroImageCountryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: education_hero_image_countries
#
#  id                      :integer          not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  country_id              :integer
#  education_hero_image_id :integer
#
# Indexes
#
#  index_education_hero_image_countries_on_country_id               (country_id)
#  index_education_hero_image_countries_on_education_hero_image_id  (education_hero_image_id)
#
