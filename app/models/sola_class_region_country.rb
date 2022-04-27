# frozen_string_literal: true

class SolaClassRegionCountry < ActiveRecord::Base
  belongs_to :sola_class_region
  belongs_to :country
end

# == Schema Information
#
# Table name: sola_class_region_countries
#
#  id                   :integer          not null, primary key
#  sola_class_region_id :integer
#  country_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_sola_class_region_countries_on_country_id            (country_id)
#  index_sola_class_region_countries_on_sola_class_region_id  (sola_class_region_id)
#
