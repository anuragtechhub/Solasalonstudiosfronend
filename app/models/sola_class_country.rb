# frozen_string_literal: true

class SolaClassCountry < ActiveRecord::Base
  belongs_to :sola_class
  belongs_to :country
end

# == Schema Information
#
# Table name: sola_class_countries
#
#  id            :integer          not null, primary key
#  sola_class_id :integer
#  country_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_sola_class_countries_on_country_id     (country_id)
#  index_sola_class_countries_on_sola_class_id  (sola_class_id)
#
