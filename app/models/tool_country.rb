# frozen_string_literal: true

class ToolCountry < ActiveRecord::Base
  belongs_to :tool
  belongs_to :country
end

# == Schema Information
#
# Table name: tool_countries
#
#  id         :integer          not null, primary key
#  tool_id    :integer
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_tool_countries_on_country_id  (country_id)
#  index_tool_countries_on_tool_id     (tool_id)
#
