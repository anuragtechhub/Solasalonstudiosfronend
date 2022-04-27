# frozen_string_literal: true

class SideMenuItemCountry < ActiveRecord::Base
  belongs_to :side_menu_item
  belongs_to :country
end

# == Schema Information
#
# Table name: side_menu_item_countries
#
#  id                :integer          not null, primary key
#  side_menu_item_id :integer
#  country_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_side_menu_item_countries_on_country_id         (country_id)
#  index_side_menu_item_countries_on_side_menu_item_id  (side_menu_item_id)
#
