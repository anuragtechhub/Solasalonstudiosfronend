class DealCountry < ActiveRecord::Base
  belongs_to :deal
  belongs_to :country
end

# == Schema Information
#
# Table name: deal_countries
#
#  id         :integer          not null, primary key
#  deal_id    :integer
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_deal_countries_on_country_id  (country_id)
#  index_deal_countries_on_deal_id     (deal_id)
#
