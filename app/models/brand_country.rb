# frozen_string_literal: true

class BrandCountry < ActiveRecord::Base
  belongs_to :brand
  belongs_to :country
end

# == Schema Information
#
# Table name: brand_countries
#
#  id         :integer          not null, primary key
#  brand_id   :integer
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_brand_countries_on_brand_id    (brand_id)
#  index_brand_countries_on_country_id  (country_id)
#
