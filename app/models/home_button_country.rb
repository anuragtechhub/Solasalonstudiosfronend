# frozen_string_literal: true

class HomeButtonCountry < ActiveRecord::Base
  belongs_to :home_button
  belongs_to :country
end

# == Schema Information
#
# Table name: home_button_countries
#
#  id             :integer          not null, primary key
#  home_button_id :integer
#  country_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_home_button_countries_on_country_id      (country_id)
#  index_home_button_countries_on_home_button_id  (home_button_id)
#
